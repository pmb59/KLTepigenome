#R script to perform functional Karhunen-Loeve Transform (KLT) in epigenomic data
#Please cite: "Uncovering the variation within epigenomic datasets using the Karhunen-Loeve transform"

args<-commandArgs(TRUE);

#Disable scientific notation
options(scipen=999)

#Required R packages
library(fda)
library(ggplot2)
library(RColorBrewer)
library(genomation)
library(GenomicRanges)
currentDir <- getwd() 

regions <- read.table(as.character(args[2]), head=F)  

#bigWig file
FILE <- as.character(args[1])
#Output Prefix
id <- as.character(args[7])

#Extension (bp)
EXT <- as.numeric(args[3]) 
#Number of B-Splines
NB <- as.numeric(args[4]) 
#Number of bins for the heatmap plot
NBins <- as.numeric(args[10])
#Number of functional principal components to compute
pcT <- as.numeric(args[8]) 
#Number of functional principal components to plot
pcP <- as.numeric(args[9]) 

CHR <- as.character(regions[,1])
STRAND <- as.character(regions[,6])
centre <- round ( (regions[,2] + regions[,3]) /2)
START <- centre - EXT
END <- centre + EXT  

GENE <- as.character(regions[,7]) 

# Check integrity of the regions
if(as.character(args[5]) == "TRUE" | as.character(args[5]) == "T"){

  chromos <- read.table("hg19.chrom.sizes",head=F)

  valid <- c()
  for (k in 1:length(CHR)){

    locata <- which( chromos$V1 == CHR[k] )
      if (length(locata)==1){                    #e.g. chrGL000213.1
        if (as.integer(START[k])>0  & as.integer(END[k]) < chromos$V2[locata] ) { valid <- c(valid,k) }
      }
  }

START  <- START[valid]
END    <- END[valid]
CHR    <- CHR[valid]
STRAND <- STRAND[valid]

GENE   <- GENE[valid]
}


# REMOVE ENCODE Blacklisted regions
#(do this in temp folder!)
system(paste('cp -n wgEncodeDacMapabilityConsensusExcludable.bed',tempdir(),sep=" "), intern=FALSE);
setwd(tempdir())

if(as.character(args[6]) == "TRUE" | as.character(args[6]) == "T"){
  
  write.table(cbind(CHR,START,END,STRAND,GENE), file =paste(id, "original.bed",sep="_"), append = FALSE, quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)
  system(paste('bedtools intersect -wa -v -a',paste(id,'original.bed',sep="_"),'-b wgEncodeDacMapabilityConsensusExcludable.bed  >', paste(id,"intersect.bed",sep="_"),sep=" "), intern=FALSE);
  #regions used:
  system(paste('cp',paste(id,'intersect.bed',sep="_"), currentDir,sep=" "), intern=FALSE);

  notBlacklisted <- read.table(paste(id,"intersect.bed",sep="_"),head=F)
  #readGeneric (genomation)
  peaks <- readGeneric(paste(id,"intersect.bed",sep="_"), header=F, keep.all.metadata = TRUE, strand = 4)


  CHR    <- notBlacklisted[,1]
  START  <- notBlacklisted[,2]
  END    <- notBlacklisted[,3]
  STRAND <- notBlacklisted[,4]
  system(paste('rm',paste(id,'original.bed',sep="_"),sep=" "), intern=FALSE);
  system(paste('rm',paste(id,'intersect.bed',sep="_"),sep=" "), intern=FALSE);

}
setwd(currentDir)



#Create FDA matrix
fdamatrix <- matrix(0.0,ncol=1+2*EXT, nrow= length(CHR))   

#Deprecated:
setwd(tempdir())

for (i in 1:length(CHR)) {

  cmmd <- paste('bigWigSummary', FILE, CHR[i], as.integer(START[i]), as.integer(END[i]), as.integer(1+2*EXT), paste("> tempR_",".txt",sep=id), sep=' ')
  x <- system(cmmd, intern=FALSE);
    	
  if(length(readLines(paste("tempR_",".txt",sep=id)))>0) {   #if no data the file is empty 

    x <- as.numeric( strsplit(x= readLines(paste("tempR_",".txt",sep=id)) ,split="\t")[[1]])

		if(STRAND[i]=="+")  { fdamatrix[i,] <- x }        #     
		if(STRAND[i]=="-")  { fdamatrix[i,] <- rev(x) }   #    

	}		
	rm(x)
	system(paste("rm",paste("tempR_",".txt",sep=id) ,sep=' '), intern=FALSE);
	
}
setwd(currentDir)

#Genomation heatmap
nBins = NBins
scaleData=FALSE
#Read bigWig
sm <- ScoreMatrixBin(target = FILE, bin.num = nBins, windows = peaks, type="bigWig",strand.aware = TRUE)
pdf(file=paste(id,"_heatmap.pdf", sep=""), height=6.5, width=3)
heatMatrix(sm, kmeans=FALSE, k=3,order=TRUE, legend.name=c("Normalized coverage"),xlab=paste("bp \n",nrow(sm)," regions",sep=""), main=id, xcoords =c(-EXT, EXT) ,winsorize=c(0,99), col=c("darkblue","yellow"))  
dev.off()

#fdamatrix <- sm





#Deprecated:

# here we have the matrix with all the profiles
# Correct non-numeric values
fdamatrix[which(is.na(fdamatrix)==TRUE)] <- 0.0
fdamatrix[which(is.nan(fdamatrix)==TRUE)] <- 0.0
fdamatrix[which(is.numeric(fdamatrix)==FALSE)] <- 0.0



#Create Functional Data Object
bspl <- create.bspline.basis(rangeval=c(-EXT,EXT),nbasis=NB, norder=4)
argvalsBS <- -EXT:EXT
fdaData <- Data2fd(y=t(fdamatrix), argvals= argvalsBS, basisobj=bspl)

# perform functional pca
pc<- pca.fd(fdobj=fdaData, nharm = pcT, harmfdPar=fdPar(fdaData),centerfns = TRUE)
#save proportions of variance
write.table(pc$varprop, file = paste(id, "varprop.txt",sep="_"), append = FALSE, quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)
#save FPC scores
write.table(pc$scores, file = paste(id,"scores.txt",sep="_"), append = FALSE, quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)

#colorcode
cl <- colorRampPalette(brewer.pal(pcT,"Set1"))(pcT) #equal number

pdf(file=paste(id,"_components.pdf", sep=""), width=3.5, height=3.5)

for (p in 1:pcP){
  par(mar=c(5,4,4,5)+.1)

  plot(-EXT:EXT, eval.fd(argvalsBS,pc$harmonics[p]),frame=FALSE ,type="l",col=cl[p],xlab="bp",main=paste(100*round(pc$varprop[p],3),"%",sep=""),ylab=paste("FPC" , as.character(p),sep="" ), lwd=2, cex.axis=1.1)

}
dev.off()

#save components valued-vector
for (p in 1:pcT){
write.table(t(eval.fd(argvalsBS,pc$harmonics[p])), file = paste(id, "components.txt",sep="_"), append = TRUE, quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)
}



pdf(file=paste(id,"_barplot.pdf", sep=""), width=3.5, height=3.5)
barplot(height=100*round(pc$varprop[1:pcT],3), col=cl , names.arg="", ylab="%",las=3,border=NA,space=0, main="ranked 50 components")
dev.off()


png(filename=paste(id,"_mean_sd.png", sep=""), width=400, height=400)
SD <- sd.fd(fdobj=fdaData)
M <- mean.fd(x=fdaData)
Mgg    <- data.frame( mean = c(eval.fd(argvalsBS,M), eval.fd(argvalsBS,M)+ eval.fd(argvalsBS,SD), eval.fd(argvalsBS,M)- eval.fd(argvalsBS,SD)), tssG = rep(argvalsBS,3), clase=c(rep("Mean",length(argvalsBS)), rep("s.d.",2*length(argvalsBS))   ) )
ff <- ggplot(Mgg , aes(tssG, mean))
ff +  geom_line(aes(colour = clase))  + ggtitle(id)  + ylab('Normalized coverage') + xlab('Distance from TSS') + geom_vline(xintercept = 0, linetype=2) + theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))    +  theme(axis.text = element_text(size = rel(1.5)), axis.title.y = element_text(size  = rel(1.5)), axis.title.x = element_text(size = rel(1.5)), plot.title = element_text(size=rel(2.5), face="bold")) + geom_line(data = data.frame( mean = eval.fd(argvalsBS,M),  tssG=argvalsBS)  , colour = "gold", size=1.6)  
dev.off()


