#R script to perform functional Karhunen-Loeve Transform (KLT) in epigenomic data
#If you use this, please cite:
#Uncovering the variation within epigenomic datasets using the Karhunen-Loeve transform

args<-commandArgs(TRUE)
library(fda)
library(ggplot2)

load("TSS.Rda")

#pdf(file="all.pdf")

#FILE="hg19.100way.phastCons.bw"
FILE=as.character( read.table("01_data.txt", head=F)$V1 )

FILE=FILE[as.numeric(args[1])]


#Prepare regions

EXT = 1500 # bp
NB = 150

START <- centre - EXT
END <- centre + EXT  
#STRAND=strand(x)    

# Check integrity of the regions
chromos <- read.table("hg19.txt",head=F)



