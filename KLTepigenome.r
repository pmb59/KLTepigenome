#R script to perform functional Karhunen-Loeve Transform (KLT) in epigenomic data
#If you use this, please cite:
#Uncovering the variation within epigenomic datasets using the Karhunen-Loeve transform

args<-commandArgs(TRUE)
library(fda)
library(ggplot2)

load("TSS.Rda")

#pdf(file="all.pdf")

#FILE="hg19.100way.phastCons.bw"
FILE=as.character(args[1])


#Prepare regions
#Extension
EXT = 1500 # bp
#Number of B-Splines
NB = 150

START <- centre - EXT
END <- centre + EXT  
#STRAND=strand(x)    

# Check integrity of the regions
chromos <- read.table("hg19.chrom.sizes",head=F)

valid <- c()
for (k in 1:length(CHR)){

        locata <- which( chromos$V1 == CHR[k] )
        if (length(locata)==1){                    #e.g. chrGL000213.1
        	if (as.integer(START[k])>0  & as.integer(END[k]) < chromos$V2[locata] ) { valid <- c(valid,k) }
        }

}

START <- START[valid]
END <- END[valid]
CHR <- CHR[valid]
STRAND <- STRAND[valid]

#OK

# REMOVE ENCODE Blacklisted regions
#(do this in temp folder)

write.table(cbind(CHR,START,END,STRAND), file = "original.bed", append = FALSE, quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)
system('bedtools intersect -wa -v -a original.bed -b wgEncodeDacMapabilityConsensusExcludable.bed  > intersect.bed', intern=FALSE);
NEWbed <- read.table("intersect.bed",head=F)
START <-  NEWbed[,2]
END <-   NEWbed[,3]
CHR <- NEWbed[,1]
STRAND <-  NEWbed[,4]
system('rm original.bed', intern=FALSE);
system('rm intersect.bed', intern=FALSE);

for (j in



