
#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(reshape2)
library(pheatmap)
library(RColorBrewer)

# read the file name from input
fileName <- toString(args[1])
lower_extreme_limit <- as.numeric(args[2])
#average_chrom_region_loci_distance <- as.numeric(args[3])

# lower_extreme_limit=-10

# fileName <- "OUTPUT_vista_example_FOREBRAIN_SHUFFLED"

dataTable <- read.table(fileName, sep="\t", header=TRUE)

matrix_dim=100
if (dim(dataTable)[1]!=matrix_dim )  {
  print(dim(dataTable))
  stop("The size of dataTable is not 100. The program will exit")   
} else {


newMat <- data.frame(dataTable$ADJUST_COORD, dataTable$EXTENSION, round(log10(dataTable$p_value),2))
colnames(newMat) <- c("ADJUST_COORD", "EXTENSION", "log10_p_value")

newMatReady <- dcast(newMat, ADJUST_COORD~EXTENSION)

rownames(newMatReady) <- newMatReady[,1]
newMatReady <- newMatReady[,-1]

rownames(newMatReady) <- paste("QUERY_", rownames(newMatReady), sep="")
colnames(newMatReady) <- paste("TSS_", colnames(newMatReady), sep="")

colmin=which.min(apply(newMatReady,MARGIN=1,min))
print(colmin)
rowmin=which.min(apply(newMatReady,MARGIN=2,min))
print(rowmin)

pdfFileName <- paste(fileName, "_heatmap.pdf", sep="")

pdfFileNameNew <- gsub("results/", "results_plot_files/", pdfFileName)

thisFontSize=18
titleText=gsub("../results_plot_files/OUTPUT_", "", pdfFileNameNew)
titleText=gsub("example_", "", titleText)
titleText=gsub("example4_", "", titleText)
titleText=gsub("_sorted", "", titleText)
titleText=gsub("_bed_logPvalues_top_GO_terms", "", titleText)
titleText=gsub("_heatmap.pdf", "", titleText)

#titleText=paste(titleText, " ACRLD=", toString(average_chrom_region_loci_distance), sep="")

breaksList = seq(lower_extreme_limit, 0, by = 0.1)

cat("min box value = ", min(newMatReady), "\n", sep="")

print(dim(newMatReady))

pheatmap(newMatReady, main=titleText, cluster_rows=FALSE, cluster_cols=FALSE, show_rownames=TRUE, show_colnames=TRUE, width=9, height=9, filename=pdfFileNameNew, fontsize=12, fontsize_row=thisFontSize, fontsize_col=thisFontSize, legend=TRUE, color = colorRampPalette((brewer.pal(n = 7, name = "RdYlBu")))(length(breaksList)),        breaks = breaksList)
dev.off();

unlink("Rplots.pdf");
    
}

