
comma_valued <- function(inputValue){
  
  return (prettyNum(inputValue,big.mark=",", preserve.width="none"))
}

# options(echo=TRUE) # if you want see commands in output file
# args <- commandArgs(trailingOnly = TRUE)
# print(args)
# 
# fileNameRegions <- args[1]

fileNameRegions <- "../data/vista_NOSE_sorted.bed"
fileNameTranscripts <- "../data/principal_transcripts_QUERY24100_TSS9400.bed"


dataTableTranscripts <- read.table(fileNameTranscripts, sep="\t", header=F, stringsAsFactors=F)
dataTableRegions <- read.table(fileNameRegions, sep="\t", header=F, stringsAsFactors=F)

colnames(dataTableRegions) <- c("chrName", "startLocus", "endLocus")

chr_array <- c('chr1', 'chr2', 'chr3', 'chr4', 'chr5', 'chr6', 'chr7', 'chr8', 'chr9', 'chr10', 'chr11', 'chr12', 'chr13', 'chr14', 'chr15', 'chr16', 'chr17', 'chr18', 'chr19', 'chr20', 'chr21', 'chr22', 'chrX')

globalRegionNumber = 1 # counter
globalRegionDiffWithTSS <- vector()
newChrStartLocus_array <- vector()
newChrEndLocus_array <- vector()
 
for(currentChrIndex in 1:length(chr_array)) {
  
dataTableRegions_currentChr <- dataTableRegions[dataTableRegions$chrName==chr_array[currentChrIndex],]

if ((dim(dataTableRegions_currentChr)[1]) >= 1) {
  
  dataTableTranscriptsCoord <- dataTableTranscripts[,1:3]
  colnames(dataTableTranscriptsCoord) <- c("chrName", "startLocus", "endLocus")
  
  dataTableTranscriptsCoord_currentChr <- dataTableTranscriptsCoord[dataTableTranscriptsCoord$chrName==chr_array[currentChrIndex],]
  
    for(i in 1:dim(dataTableRegions_currentChr)[1])
    {
    
      # Let's consider the i_th region
      thisRegion <- dataTableRegions_currentChr[i:i,]
      cat("\n\nfor region #",globalRegionNumber," ",sep="")
      cat(thisRegion$chrName, "-",sep="")
      cat(thisRegion$startLocus, "-",sep="")
      cat(thisRegion$endLocus, " the nearest TSS is ",sep="")
      
      array_diff <- (abs(dataTableTranscriptsCoord_currentChr[,]$startLocus - thisRegion$startLocus))
    
      index_min <- which(array_diff == min(array_diff))
      thisDiff <- array_diff[index_min]
      
      cat(dataTableTranscriptsCoord_currentChr[index_min,]$chrName, "-",sep="")
      cat(dataTableTranscriptsCoord_currentChr[index_min,]$startLocus, "-",sep="")
      cat(dataTableTranscriptsCoord_currentChr[index_min,]$endLocus, " ",sep="")
      
      cat(" (difference = ",comma_valued(thisDiff),") \n",sep="")
      
      regionSize <- abs(thisRegion$endLocus - thisRegion$startLocus)
      cat("region size = ", comma_valued(regionSize), "\n", sep="")
      
      globalRegionDiffWithTSS[globalRegionNumber] <- thisDiff
  
      # SELECT A RANDOM TSS
      randomTssIndex <- sample(1:dim(dataTableTranscriptsCoord_currentChr)[1],1)
      cat("Randomly selected TSS (index=",randomTssIndex,"): ", sep="")
      randomTSS <- dataTableTranscriptsCoord_currentChr[randomTssIndex, ]
      
      cat(" ",randomTSS$chrName, "-", randomTSS$startLocus, "-", randomTSS$endLocus, " \n", sep="")
  
      # select the chromStart having delta distance from that TSS found
      # (or create?)
      
      newChrStartLocus <- (randomTSS$startLocus)+thisDiff
      cat("newChrStartLocus: ", comma_valued(newChrStartLocus), "\t", sep="")
      newChrStartLocus_array[globalRegionNumber] <- newChrStartLocus
      
      # the end locus is the newChrStartLocus + the original chromosome region size
      newChrEndLocus <- newChrStartLocus + regionSize
      cat("newChrEndLocus: ", comma_valued(newChrEndLocus), "\n", sep="")
      newChrEndLocus_array[globalRegionNumber] <- newChrEndLocus
      
      cat(thisRegion$chrName,"-",newChrStartLocus,"-",newChrEndLocus, sep="")
      
      globalRegionNumber = globalRegionNumber + 1
    }
  
  }

}

newDataFrame <- as.data.frame(cbind(dataTableRegions$chrName, newChrStartLocus_array, newChrEndLocus_array), stringsAsFactors = FALSE)

colnames(newDataFrame) <- c("newChrName", "newStart", "newEnd")

newDataFrameOrdered <- newDataFrame[ order(newDataFrame$newChrName, as.numeric(newDataFrame$newStart)), ]

colnames(newDataFrameOrdered) <- c("newChrName", "newStart", "newEnd")
head(newDataFrameOrdered)
tail(newDataFrameOrdered)
dim(newDataFrameOrdered)

onlyFileNameRegions <- basename(fileNameRegions)


outputFile <- paste("../data/randomlyShuffledNew_",onlyFileNameRegions, sep="")

write.table(newDataFrameOrdered, outputFile, sep="\t", quote=F, row.names=F, col.names=F)


