
#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# read the file name from input
fileName <- toString(args[1])

# read the Ensemble ID's of the genes from file
listIDs <- scan(fileName, what="", sep="\n")

library("gProfileR")

significantValue <- "F"

# if (grepl("SHUFFLE", fileName)) {
#   significantValue <- "F"
# }


gprofiler(listIDs, organism = "hsapiens", significant=significantValue, ordered_query=T)