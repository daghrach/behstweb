

options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
print(args)


# fileName <- "vista_example4_Human_sorted_logPvalues_top_GO_terms"
fileName <- toString(args[1])

dataTable <- read.table(fileName, sep="\t", header=FALSE);

colnames(dataTable) <- c("values", "GO_ID", "subGO", "GO term name", "ADJUST_COORD", "EXTENSION");

dataTable$log10value <- log10(dataTable$values)

pdfFile <- paste(fileName, ".pdf", sep = "")
pdfFile <- gsub("results", "results/plot_files", pdfFile)
print(pdfFile)
pdf(pdfFile, width=16, height=8, paper='special')

y_inf=-30
y_sup=0

if(min(dataTable$log10value)<y_inf) {

  y_inf <- min(dataTable$log10value)

}

plot(dataTable$ADJUST_COORD, dataTable$log10value, type="b", xlab="ADJUST_COORD range (bp)", ylab="log10(p-value)", ylim=c(y_inf,y_sup))
title(fileName)
grid(5, 5, lwd = 2)

dev.off()

# # # # # #
# x <- dataTable$ADJUST_COORD
# y <- dataTable$log10value
# z <- dataTable$EXTENSION
# 
# scatterplot3(x,y,z)

text(dataTable$ADJUST_COORD, dataTable$log10value, labels=EXTENSION, cex= 0.7)