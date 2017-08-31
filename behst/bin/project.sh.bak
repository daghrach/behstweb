#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#
set -o nounset -o pipefail -o errexit
#set -o xtrace

# dependencies:
# Python pybedtools
# R gProfileR


startTime=`date +%s`
millisec_time_number=$(date +%s)

printf "\n :: BEHST - Biological Enrichment of Hidden Sequence Targets ::\n\n"

# INPUT_FILE="ENCODE_myc.bed"
INPUT_FILE=$1
QUERY_AC=$2
TSS_EXT=$3
# 16000

if [ ! -f $INPUT_FILE ]; then
    printf "(project.sh) File $INPUT_FILE not found!\n The program will stop"
    exit 1
fi

if [ $QUERY_AC = "DEFAULT_EQ" ]; then 
   QUERY_AC=24100
fi
if [ $TSS_EXT = "DEFAULT_ET" ]; then 
   TSS_EXT=9400
fi

printf "\n The query extension parameter is  "$QUERY_AC "\n"
printf "\n The TSS extension parameter is  "$TSS_EXT "\n\n"


filename=$(basename "$INPUT_FILE")
filename="${filename%.*}"
filename=$filename".bed"

INPUT_FILE_NEW=${filename//./_}

RESULTS_DIR="../results"
TEMP_DIR="../temp/rand_"${millisec_time_number}
mkdir $TEMP_DIR

GENE_ANNOTATION_FILE="../data/gencode.v19.annotation.gtf_withproteinids"
TRANSCRIPT_ANNOTATION_FILE="../data/appris_data_principal.txt"
#HI_C_FILE="../../../_project/data/2015-01-15_Miriam_data/original_GEO_data_files/GSE63525_GM12878_primary_HiCCUPS_looplist_NEW.txt"
HI_C_FILE="../data/hic_allCellTypes"
HI_C_FILTERED_TEMP_FILE="hi_c_filtered.txt"
OUTPUT_FILE=${INPUT_FILE_NEW}"_QUERY"${QUERY_AC}"_TSS"${TSS_EXT}"_gene_list.txt"

ANALYSIS_RESULTS="gProfiler_results_QUERY"${QUERY_AC}"_TSS"${TSS_EXT}

# to read input from stdin or user-specified argument
# if there is at least one argument and the first argument is a file, assign it to input, otherwise assign stdin to input
# [ $# -ge 1 -a -f "S1" ] && INPUT="$1" || INPUT="-"



python hiC_parser.py "$HI_C_FILE" | sort -V > "${TEMP_DIR}/$HI_C_FILTERED_TEMP_FILE"
python gene_annotation_parser.py "$GENE_ANNOTATION_FILE" "$TRANSCRIPT_ANNOTATION_FILE" $TSS_EXT > "${TEMP_DIR}/principal_transcripts.bed"


# Similar to bedtools intersect, bedtools window searches for overlapping features in A and B. However, window adds a specified number (1000, by default) of base pairs upstream and downstream of each feature in A. In effect, this allows features in B that are “near” features in A to be detected.

sort -V $INPUT_FILE | bedtools window -w $QUERY_AC -a stdin -b "${TEMP_DIR}/$HI_C_FILTERED_TEMP_FILE" | awk -F $'\t' '{print $(NF-2), $(NF-1), $NF}' OFS=$'\t' | sort -V | uniq | bedtools window -w $QUERY_AC -a stdin -b "${TEMP_DIR}/principal_transcripts.bed" | cut -f7 | sort -V | uniq > "${RESULTS_DIR}/$OUTPUT_FILE"

# comment the following line to save the transcripts
rm "${TEMP_DIR}/principal_transcripts.bed" "${TEMP_DIR}/$HI_C_FILTERED_TEMP_FILE"

printf "\nBEHST generated the resulting gene list in the following file: \n "${RESULTS_DIR}/$OUTPUT_FILE"\n\n"

wc -l ${RESULTS_DIR}/$OUTPUT_FILE

# uncomment the following 2 lines to save the transcripts
# printf "the program will stop here"
# exit

GPROFILER_OUTPUT_FILE=${RESULTS_DIR}/${INPUT_FILE_NEW}_${ANALYSIS_RESULTS}_rev
Rscript gProfilerCall.r ${RESULTS_DIR}/$OUTPUT_FILE > $GPROFILER_OUTPUT_FILE

# head $GPROFILER_OUTPUT_FILE

# grep -A 15 "term.name" $GPROFILER_OUTPUT_FILE

line_of_term_id=$(sed -n '/term.id/=' $GPROFILER_OUTPUT_FILE) # we understand the line number of the term.id list
number_of_GO_terms=$((line_of_term_id-2))
number_of_GO_lines=$((line_of_term_id-1))

LEFT_TEMP_GO_FILE=${TEMP_DIR}/"temp_left_GO_line_file_rand"${millisec_time_number}
LEFT_TEMP_GO_FILE2=${TEMP_DIR}/"temp_left_GO_line_file2_rand"${millisec_time_number}
LEFT_TEMP_GO_FILE3=${TEMP_DIR}/"temp_left_GO_line_file3_rand"${millisec_time_number}
head -$number_of_GO_lines $GPROFILER_OUTPUT_FILE > $LEFT_TEMP_GO_FILE
tail -n +2 $LEFT_TEMP_GO_FILE > $LEFT_TEMP_GO_FILE2

central_part_start_line=$((number_of_GO_lines+1))
central_part_end_line=$((central_part_start_line+number_of_GO_terms))
CENTRAL_TEMP_GO_FILE=${TEMP_DIR}/"temp_central_GO_line_file_rand"${millisec_time_number}
CENTRAL_TEMP_GO_FILE2=${TEMP_DIR}/"temp_central_GO_line_file2_rand"${millisec_time_number}
CENTRAL_TEMP_GO_FILE3=${TEMP_DIR}/"temp_central_GO_line_file3_rand"${millisec_time_number}

sed -n ${central_part_start_line}','${central_part_end_line}'p' $GPROFILER_OUTPUT_FILE > $CENTRAL_TEMP_GO_FILE
tail -n +2 $CENTRAL_TEMP_GO_FILE > $CENTRAL_TEMP_GO_FILE2



second_part_start_line=$((number_of_GO_lines*2+1))
second_part_end_line=$((second_part_start_line+number_of_GO_terms))
RIGHT_TEMP_GO_FILE=${TEMP_DIR}/"temp_right_GO_line_file_rand"${millisec_time_number}
RIGHT_TEMP_GO_FILE2=${TEMP_DIR}/"temp_right_GO_line_file2_rand"${millisec_time_number}
RIGHT_TEMP_GO_FILE3=${TEMP_DIR}/"temp_right_GO_line_file3_rand"${millisec_time_number}

sed -n ${second_part_start_line}','${second_part_end_line}'p' $GPROFILER_OUTPUT_FILE > $RIGHT_TEMP_GO_FILE
tail -n +2 $RIGHT_TEMP_GO_FILE > $RIGHT_TEMP_GO_FILE2

sed 's/ \+ /\t/g' $LEFT_TEMP_GO_FILE2 > ${LEFT_TEMP_GO_FILE3}
sed 's/ \+ /\t/g' $CENTRAL_TEMP_GO_FILE2 > ${CENTRAL_TEMP_GO_FILE3}
sed 's/ \+ /\t/g' $RIGHT_TEMP_GO_FILE2 > ${RIGHT_TEMP_GO_FILE3}

MERGED_TEMP_GO_FILE=${TEMP_DIR}/"temp_merged_GO_line_file_rand"${millisec_time_number}
MERGED_TEMP_GO_FILE2=${TEMP_DIR}/"temp_merged_GO_line_file2_rand"${millisec_time_number}
MERGED_TEMP_GO_FILE3=${TEMP_DIR}/"temp_merged_GO_line_file3_rand"${millisec_time_number}
paste $LEFT_TEMP_GO_FILE3 $CENTRAL_TEMP_GO_FILE3 $RIGHT_TEMP_GO_FILE3 > $MERGED_TEMP_GO_FILE
sed 's/ \+ /\t/g' $MERGED_TEMP_GO_FILE > $MERGED_TEMP_GO_FILE2

TAB=$'\t' 


MERGED_TEMP_GO_FILE3_SORTED=${MERGED_TEMP_GO_FILE3}"_sorted"
MERGED_TEMP_GO_FILE3_SORTED2=${MERGED_TEMP_GO_FILE3_SORTED}"_2"

sed -r 's/(TRUE|FALSE|NA)[[:space:]]*//g' $MERGED_TEMP_GO_FILE2 > $MERGED_TEMP_GO_FILE3
#sed -r "s/${TAB}(TRUE|FALSE|NA)[[:space:]]*//g" $MERGED_TEMP_GO_FILE2 > $MERGED_TEMP_GO_FILE3

# sed 's/FALSE //g' $MERGED_TEMP_GO_FILE2 >> $MERGED_TEMP_GO_FILE3 # TO IMPROVE
sort -k3,3g  $MERGED_TEMP_GO_FILE3 > $MERGED_TEMP_GO_FILE3_SORTED


cut -f3,10,11,14 $MERGED_TEMP_GO_FILE3_SORTED > $MERGED_TEMP_GO_FILE3_SORTED2

#sed "1 s/$/ ${TAB}${QUERY_AC}/" $MERGED_TEMP_GO_FILE3_SORTED2 > ${GPROFILER_OUTPUT_FILE}"_sorted_rand"${millisec_time_number} # ? ? ?

## ORIGINAL
grep "GO:" -m 1 $MERGED_TEMP_GO_FILE3_SORTED2 >  ${GPROFILER_OUTPUT_FILE}"_sorted_rand"${millisec_time_number} || true

# result=$(grep "GO:" -m 1 $MERGED_TEMP_GO_FILE3_SORTED2 || true)
# 
# if [[ $result == true ]]; then
#     printf "$result" > ${GPROFILER_OUTPUT_FILE}"_sorted_rand"${millisec_time_number}
#   else
#     printf "${TAB}${TAB}${TAB}${TAB}" > ${GPROFILER_OUTPUT_FILE}"_sorted_rand"${millisec_time_number}
# fi

sed "1 s/$/ ${TAB}${QUERY_AC} ${TAB}${TSS_EXT}/" ${GPROFILER_OUTPUT_FILE}"_sorted_rand"${millisec_time_number}

rm $LEFT_TEMP_GO_FILE
rm $LEFT_TEMP_GO_FILE2
rm $RIGHT_TEMP_GO_FILE
rm $RIGHT_TEMP_GO_FILE2
rm $CENTRAL_TEMP_GO_FILE
rm $CENTRAL_TEMP_GO_FILE2
rm $MERGED_TEMP_GO_FILE # output file
rm $MERGED_TEMP_GO_FILE2
rm $MERGED_TEMP_GO_FILE3
rm $MERGED_TEMP_GO_FILE3_SORTED
rm $RIGHT_TEMP_GO_FILE3
rm $CENTRAL_TEMP_GO_FILE3
rm $LEFT_TEMP_GO_FILE3


#GO_LIST_FILE=${GPROFILER_OUTPUT_FILE}"GO_term_list_AC"${QUERY_AC}"_EXT"${TSS_EXT}"_sorted_rand"${millisec_time_number}

GO_LIST_FILE=${GPROFILER_OUTPUT_FILE}"GO_term_list_rand"${millisec_time_number}

grep "GO:" $MERGED_TEMP_GO_FILE3_SORTED2 > $GO_LIST_FILE

printf "\n BEHST generated the output GO list into the following file: \n %s\n\n" $GO_LIST_FILE

endTime=`date +%s`
runtime=$((endTime-startTime))
printf 'project.sh Total running time: %dhours,  %dminutes, %dseconds\n' $(($runtime/3600)) $(($runtime%3600/60)) $(($runtime%60))

rm -r $TEMP_DIR

# to retrieve a genome assembly (solution from https://www.biostars.org/p/98121/):
# mysql --user=genome --host=genome-mysql.cse.ucsc.edu -A -e
# \"select chrom, size from hg19.chromInfo\" > hg19.genome
