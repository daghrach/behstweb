#!/usr/bin/python2.7

# To run this script:
#
# ./behst.py ../data/pressto_LUNG_enhancers.bed dataFolderName


import argparse
import subprocess

from time import sleep
from datetime import datetime
start_time = datetime.now()
print '### BEHST start time ', start_time


INPUT_FILE="unknown"
BEHST_DATA_FOLDER="unknown"
TSS_EXT="default_et"
QUERY_AC="default_eq"
GENE_ANNOTATION_FILE="default_gene_annotation_file"
TRANSCRIPT_ANNOTATION_FILE="default_transcript_annotation_file"
HI_C_FILE="default_long_range_interaction_file"


citation = "Citation: Chicco D, Bi HS, Reimand J, Hoffman MM. 2017. \"BEHST: Genomic set enrichment analysis enhanced through integration of chromatin long-range interactions\". In preparation."
parser = argparse.ArgumentParser(epilog=citation)


parser.add_argument("INPUT_BED_FILE", help="input BED file of genomic regions")
parser.add_argument("BEHST_DATA_FILES_FOLDER", help="path to the folder where you downloaded the default BEHST data files with ./download_behst_data.sh")
parser.add_argument("-T", "--target-extension", help="target extension basepair integer. Default is 9400.\n", action="store")
parser.add_argument("-Q", "--query-extension", help="query extension basepair integer. Default is 24100.\n", action="store")
parser.add_argument("-g", "--gene-annotation-file", help="path of the gene annotation file (.gtf format). Default is the GENCODE annotation v.19 file (gencode.v19.annotation_withproteinids.gtf).\n", action="store")
parser.add_argument("-t", "--transcript-file", help="path to the principal transcript file (.bed format). Default is APPRIS transcript 2017_01.v20 file (appris_data_principal.bed)\n\n", action="store")
parser.add_argument("-i", "--interaction-file", help="path to the chromatin interactions file (.hiccups format). Default is the Hi-C HiCCUPS from Lieberman-Aiden 2014 (hic_8celltypes.hiccups).\n\n", action="store")
parser.add_argument("-v", "--version", help="current BEHST version\n", action="version", version='%(prog)s (version 0.6)')

args = parser.parse_args()
print args


INPUT_FILE = args.INPUT_BED_FILE
BEHST_DATA_FOLDER = args.BEHST_DATA_FILES_FOLDER

if args.target_extension:
  TSS_EXT = args.target_extension

if args.query_extension:
  QUERY_AC = args.query_extension

if args.gene_annotation_file:
  GENE_ANNOTATION_FILE = args.gene_annotation_file

if args.transcript_file:
  TRANSCRIPT_ANNOTATION_FILE = args.transcript_file

if args.interaction_file:
  HI_C_FILE = args.interaction_file
  

print "INPUT_FILE: ",INPUT_FILE
print "BEHST_DATA_FOLDER: ",BEHST_DATA_FOLDER
print "TSS_EXT: ",TSS_EXT
print "QUERY_AC: ",QUERY_AC
print "GENE_ANNOTATION_FILE: ",GENE_ANNOTATION_FILE
print "TRANSCRIPT_ANNOTATION_FILE: ",TRANSCRIPT_ANNOTATION_FILE
print "HI_C_FILE: ",HI_C_FILE

# subprocess.call(['./project.sh', INPUT_FILE, BEHST_DATA_FOLDER, QUERY_AC, TSS_EXT, GENE_ANNOTATION_FILE, TRANSCRIPT_ANNOTATION_FILE, HI_C_FILE])
# $PREFIX/bin

subprocess.call(['/usr/bin/env', 'bash', 'behst/bin/project.sh', INPUT_FILE, BEHST_DATA_FOLDER, QUERY_AC, TSS_EXT, GENE_ANNOTATION_FILE, TRANSCRIPT_ANNOTATION_FILE, HI_C_FILE])

stop_time = datetime.now()
print '### BEHST end time', stop_time
elapsed_time = stop_time - start_time
print 'Executed time', elapsed_time   