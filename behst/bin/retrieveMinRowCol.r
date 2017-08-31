

#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(reshape2)
library(pheatmap)
library(RColorBrewer)


#average_chrom_region_loci_distance <- as.numeric(args[3])


# fileName <- "OUTPUT_vista_example_FOREBRAIN_SHUFFLED"

# 
createMatrixFromTableList <- function(fileName){
  
  dataTable <- read.table(fileName, sep="\t", header=TRUE)
  newMat <- data.frame(dataTable$ADJUST_COORD, dataTable$EXTENSION, round(log10(dataTable$p_value),2))
  colnames(newMat) <- c("ADJUST_COORD", "EXTENSION", "log10_p_value")
  
  newMatReady <- dcast(newMat, ADJUST_COORD~EXTENSION)
  
  rownames(newMatReady) <- newMatReady[,1]
  newMatReady <- newMatReady[,-1]
  
  rownames(newMatReady) <- paste("QUERY_", rownames(newMatReady), sep="")
  colnames(newMatReady) <- paste("TSS_", colnames(newMatReady), sep="")
  
  cat("sum(newMat)", as.numeric(sum(newMat)), sep="")

  return (newMatReady)
}

# Function which selects and returns the minimum element of a matrix
get_min_matrix_element <- function(mat){

  colmin=which.min(apply(mat,MARGIN=1,min))
  print(colmin)
  rowmin=which.min(apply(mat,MARGIN=2,min))
  print(rowmin)
}

# read the file name from input
fileNameArray <- vector()
fileNameArray[1] <- "../results/OUTPUT_randomlyShuffledNew_vista_HEART_sorted_bed_logPvalues_top_GO_terms_rand41867"
fileNameArray[2] <- "../results/OUTPUT_randomlyShuffledNew_vista_HINDBRAIN_sorted_bed_logPvalues_top_GO_terms_rand506982"
fileNameArray[3] <- "../results/OUTPUT_randomlyShuffledNew_vista_FOREBRAIN_sorted_bed_logPvalues_top_GO_terms_rand819313"
fileNameArray[4] <- "../results/OUTPUT_randomlyShuffledNew_vista_NOSE_sorted_bed_logPvalues_top_GO_terms_rand140345"
fileNameArray[5] <- "../results/OUTPUT_randomlyShuffledNew_vista_EYE_sorted_bed_logPvalues_top_GO_terms_rand711478_COMPLETE"
fileNameArray[6] <- "../results/OUTPUT_randomlyShuffledNew_vista_LIMB_sorted_bed_logPvalues_top_GO_terms_rand429170"
fileNameArray[7] <- "../results/OUTPUT_randomlyShuffledNew_vista_MIDBRAIN_sorted_bed_logPvalues_top_GO_terms_rand654088_COMPLETE2"
  

i=1
matSum <- createMatrixFromTableList(fileNameArray[i])  

for(i in 2:length(fileNameArray))
{
  newMat <- createMatrixFromTableList(fileNameArray[i])  
  matSum <- matSum + newMat
}

get_min_matrix_element(thisMat)