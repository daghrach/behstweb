
#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# read the file name from input
fileName <- toString(args[1])

library("ggplot2");

dataTable <- read.table(fileName, sep="\t", header=F)


colnames(dataTable) <- c("chrName", "startLocus", "endLocus")

number_of_chrom_regions <- dim(dataTable)[1]
locus_differences <- as.data.frame(as.numeric(abs(dataTable$startLocus - dataTable$endLocus)))
colnames(locus_differences) <- c("difference")
locus_differences$pos <- row.names(locus_differences)

sum_of_locus_diffences <- sum(locus_differences$difference)


#pdfFile <- gsub(".bed", ".pdf", fileName)
#histogram_name <- gsub("data/", "results/plot_files/hist_", pdfFile)

# pdf(histogram_name)
# qplot(locus_differences$difference, geom="histogram", bins=50, ylim = c(0, 50))
# dev.off()

average_chrom_region_length = round(sum_of_locus_diffences/number_of_chrom_regions)

cat("\nThe average langth of the chromosome regions for", fileName, " is ", average_chrom_region_length, "\n\n")

cat(average_chrom_region_length)
