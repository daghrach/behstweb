#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(reshape2)
library(pheatmap)
library(RColorBrewer)


#average_chrom_region_loci_distance <- as.numeric(args[3])


# fileName <- "OUTPUT_vista_example_FOREBRAIN_SHUFFLED"
createMatrixFromTableList <- function(fileName){
  
  dataTable <- read.table(fileName, sep="\t", header=TRUE)
  newMat <- data.frame(dataTable$ADJUST_COORD, dataTable$EXTENSION, round(log10(dataTable$p_value),2))
  colnames(newMat) <- c("ADJUST_COORD", "EXTENSION", "log10_p_value")
  
  newMatReady <- dcast(newMat, ADJUST_COORD~EXTENSION)
  
  rownames(newMatReady) <- newMatReady[,1]
  newMatReady <- newMatReady[,-1]
  
  rownames(newMatReady) <- paste("QUERY_", rownames(newMatReady), sep="")
  colnames(newMatReady) <- paste("TSS_", colnames(newMatReady), sep="")
  
  return (newMatReady)
}

thisMat <- createMatrixFromTableList(toString(args[1]))

cat("sum(thisMat) = ", as.numeric(sum(thisMat)), "\n", sep="")