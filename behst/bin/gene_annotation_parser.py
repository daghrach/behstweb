#!/usr/bin/env python2.7

import sys
import pandas as pd
import pybedtools as pbt
import time

EXTENSION = int(sys.argv[3])
#EXTENSION = 16000

GENOME="hg19"
START_BASAL_ADJUST = 5000
STOP_BASAL_ADJUST = 1000

PRINT_TSS_TO_FILE = False # Davide

# Turn off setting with copying warning (pandas)
pd.options.mode.chained_assignment = None  # default='warn'

"""
sys.argv[1] is GENCODE annotation file
sys.argv[2] is APPRIS annotation file
"""
#output = str(sys.argv[1]).split('.gtf')[0] + '_filtered.bed'

"""
Read in principal transcript isoforms data file and keep only 
ENST ID's of principal transcripts
"""
transcripts_df = pd.read_csv(sys.argv[2], header=None, sep='\t')
transcripts_df.rename(columns={0:'name', 1: 'gene', 2:'transcript', 
                               3: 'CCDS', 4: 'tag'}, inplace=True)
transcripts_df['tag'] = pd.DataFrame(transcripts_df['tag'].
                                     str.split(':').
                                     tolist())[0]
# Keep only 'PRINCIPAL' tagged transcripts
transcripts_df = transcripts_df[transcripts_df['tag'] == 'PRINCIPAL']
# Keep rows with unique ENSG ID's
transcripts_df.drop_duplicates('gene', inplace=True)
# Keep ENST ID column
transcripts_df.drop(['name', 'gene', 'CCDS', 'tag'], axis=1, inplace=True)
transcripts_df.reset_index(inplace=True, drop=True)

# Read in gene annotation file
gene_annotation_df = pd.read_csv(sys.argv[1], sep='\t', 
                                 header=None, skiprows=5)
gene_annotation_df.rename(columns={0:'chrom', 1:'source', 
                                   2:'feature', 3: 'start', 
                                   4:'end', 5:'score', 
                                   6:'strand', 7:'frame', 
                                   8:'tags'}, inplace=True)

# Keep only rows with 'transcript' features, exclude chrM features
gene_annotation_df = gene_annotation_df[(gene_annotation_df['feature'] 
                                         =='transcript') & 
                                        (gene_annotation_df['chrom'] 
                                         != 'chrM')]
gene_annotation_df.reset_index(inplace=True, drop=True)

transcript_ID_df = pd.DataFrame(pd.DataFrame(gene_annotation_df['tags'].
                                           str.split(' ').
                                           tolist())[3].str.split('.').
                              tolist())[0].str.lstrip('"')
gene_ID_df = pd.DataFrame(pd.DataFrame(gene_annotation_df['tags'].
                                     str.split(' ').
                                     tolist())[1].str.split('.').
                        tolist())[0].str.lstrip('"')

gene_annotation_df.drop(['tags'], axis=1, inplace=True)
gene_annotation_df.loc[:,'gene'], gene_annotation_df.loc[:,
    'transcript'] = gene_ID_df, transcript_ID_df

# create df containing only principal isoforms of protein-coding genes
merged_df = pd.merge(gene_annotation_df, transcripts_df, 
                     on='transcript', how='inner')

# delete extraneous columns
merged_df.drop(['source', 'feature', 'transcript', 'frame'], 
               axis=1, inplace=True)

"""
Rearrange merged_df columns to match BED format:
<chrom>    <start>    <end>    <name>    <score>    <strand>
"""
merged_df = merged_df[['chrom', 'start', 'end', 
                       'gene', 'score', 'strand']]
merged_df.loc[:,['start', 
                 'end']] = merged_df.loc[:,['start',
                                            'end']].astype(int)

# Create BedTool object from merged_df
merged_bedtool = pbt.bedtool.BedTool.from_dataframe(merged_df)
merged_bedtool = merged_bedtool.sort()

"""
<start> (if strand is +) or  <stop> (if strand is -) is used                                         
as TSS and is duplicated for adjustments below   
"""
def TSS(feature):
    if feature.strand == '+':
        feature.stop = feature.start
    else:
        feature.start = feature.stop
    return feature

#(original) merged_bedtool = merged_bedtool.each(TSS).saveas()

if PRINT_TSS_TO_FILE == False:
  merged_bedtool = merged_bedtool.each(TSS).saveas()
else: # True
  tssFileName = "../temp/tss_list_"+str(time.time())+".bed" # Davide
  print tssFileName  # Davide
  merged_bedtool = merged_bedtool.each(TSS).saveas(tssFileName)  # Davide


"""
Adjust chromStart and chromEnd coordinates to establish basal cis-
regulatory region for each gene. The + 1 and -1 adjustments to 
START_BASAL_ADJUST and STOP_BASAL_ADJUST correct for 1-based closed 
(gtf format) to 0-based half-open (BED format)
"""
merged_bedtool = merged_bedtool.slop(s=True, 
                                     l=(START_BASAL_ADJUST + 1), 
                                     r=(STOP_BASAL_ADJUST - 1), 
                                     genome=GENOME)

# Convert back to df from BedTool object to perform 5' and 3' extensions
merged_basal_df = merged_bedtool.to_dataframe()
merged_adjusted_df = merged_basal_df.copy()

curr_i = 0
prev = None
next = merged_basal_df.loc[curr_i + 1,]

# Logic to perform extensions partially adapted from GREAT software
# McLean et al., Nature Biotechnology 2010
while curr_i < len(merged_basal_df):
    merged_adjusted_df.loc[curr_i, 
                           'start'] = max(min(merged_basal_df.loc[curr_i, 
                                                                  'start'],
                                              max((prev['end'] + 1 \
                                                   if prev is not None \
                                                   else None), \
                                                  merged_basal_df.loc[curr_i, 
                                                                      'start'] \
                                                          - EXTENSION)), 0)
    merged_adjusted_df.loc[curr_i, 
                           'end'] = max(merged_basal_df.loc[curr_i, 
                                                            'end'],
                                        min((next['start'] - 1 
                                             if next is not None else
                                             (merged_basal_df.loc[curr_i, 
                                                                  'end']
                                              + EXTENSION)),
                                            merged_basal_df.loc[curr_i, 'end'] + 
                                            EXTENSION))

#    print 'on row ' + str(curr_i) +
#                           ' || ' + 
#                           merged_basal_df.loc[curr_i, 'chrom'] 

#    print(str(merged_basal_df.loc[curr_i, 'chromStart']) + " " +
#          str(merged_basal_df.loc[curr_i, 'chromEnd']) + " ---> " +
#          str(merged_adjusted_df.loc[curr_i, 'chromStart']) + " " +
#          str(merged_adjusted_df.loc[curr_i, 'chromEnd']))

    curr_i += 1
    prev = merged_basal_df.loc[curr_i - 1,]
    if curr_i < (len(merged_basal_df) - 1):
        next = merged_basal_df.loc[curr_i + 1,]
    else:
        next = None

"""
Convert from df back to BedTool object to truncate chromStart 
and chromEnd coordinates according to lengths of corresponding chromosomes.
"""
merged_adjusted_bedtool = pbt.bedtool.BedTool.from_dataframe(merged_adjusted_df)
merged_adjusted_bedtool = merged_adjusted_bedtool.truncate_to_chrom(genome=GENOME)

#merged_bed.saveas(output)
# Output (tab-delimited, BED format) to stdout
merged_adjusted_df = merged_adjusted_bedtool.to_dataframe()
merged_adjusted_df.to_csv(sys.stdout, sep='\t', header=False, index=False)
