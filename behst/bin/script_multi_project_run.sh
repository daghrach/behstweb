#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#
set -o nounset -o pipefail -o errexit
set -o xtrace

#module load bedtools python

startTime=`date +%s`

INPUT_FILE=$1

if [ ! -f $INPUT_FILE ]; then
    echo "(script_multi_project_run.sh) File $INPUT_FILE not found!\n The program will stop"
    exit 1
fi


filename=$(basename "$INPUT_FILE")
filename="${filename%.*}"
filename=$filename".bed"

millisec_time_number=$(date +%s)
millisec_time_number=$(shuf -i1-1000000 -n1)

INPUT_FILE_NEW=${filename//./_}
TEMP_OUTPUT_FILE="../temp/temp_output_file_rand"$millisec_time_number
if [ -f $TEMP_OUTPUT_FILE ] ; then
    rm $TEMP_OUTPUT_FILE
fi
OUTPUT_FILE="../results/OUTPUT_"$INPUT_FILE_NEW"_logPvalues_top_GO_terms_rand"$millisec_time_number

TEMP_OUTPUT_FILE2=$TEMP_OUTPUT_FILE"_vol2"

adjust_upper_limit=30000 # 30k bp
adjust_coord_start=100
adjust_coord=100
adjust_range_increment=3000 # 6000

extension_this=$adjust_coord_start 
extension_upper_limit=$adjust_upper_limit
extension_range_increment=$((100+$adjust_range_increment))  
#thisExtension=16000

while ((extension_this < extension_upper_limit))
do  
  while ((adjust_coord < adjust_upper_limit))
  do  
    sh project.sh $INPUT_FILE $adjust_coord $extension_this >> $TEMP_OUTPUT_FILE 2>> $TEMP_OUTPUT_FILE
    adjust_coord=$((adjust_coord+$adjust_range_increment))  
  done
  adjust_coord=$adjust_coord_start
  extension_this=$((extension_this+$extension_range_increment))  
done

## ORIGINAL
grep "GO:[0-9]" $TEMP_OUTPUT_FILE > $TEMP_OUTPUT_FILE2 || true
#grep "\#\#\#$" $TEMP_OUTPUT_FILE > $OUTPUT_FILE || true

# grep_result=$(grep "GO:[0-9]" $TEMP_OUTPUT_FILE || true)
# 
# if [[ $grep_result== true ]]; then
#     echo "$grep_result" > $OUTPUT_FILE
#     head $OUTPUT_FILE
#   else
#     echo "The grep GO: command returned false"
# fi

sed -i '1s/^/p_value	GO_term_ID	GO_subontology	GO_term_name	ADJUST_COORD	EXTENSION\n/' $TEMP_OUTPUT_FILE2

sed "s/[']//g" $TEMP_OUTPUT_FILE2 > $OUTPUT_FILE

head $OUTPUT_FILE

rm $TEMP_OUTPUT_FILE
rm $TEMP_OUTPUT_FILE2

# Rscript pvaluesPlotGenerator.r $OUTPUT_FILE
lower_extreme_limit=-10

# average_chrom_region_loci_distance=$(Rscript chromRegionLength.r $INPUT_FILE)

Rscript plot_heatmaps.r $OUTPUT_FILE $lower_extreme_limit

endTime=`date +%s`
runtime=$((endTime-startTime))
printf 'project.sh Total running time: %dhours,  %dminutes, %dseconds\n' $(($runtime/3600)) $(($runtime%3600/60)) $(($runtime%60))