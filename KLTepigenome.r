#R script to perform functional Karhunen-Loeve Transform (KLT) in epigenomic data
#Please cite:
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


for (j in 1:length(FILE)){   #  length(FILE)


#library(ChIPpeakAnno)
#data(TSS.human.GRCh37)
#x<- TSS.human.GRCh37
#centre <- rep(NA,dim(x)[1])
#fw <- which(strand(x)==1);
#rv <- which(strand(x)==-1);
#temp <- as.data.frame(ranges(x))
#centre[fw] <- temp$start[fw]
#centre[rv] <- temp$end[rv]
# regions
#CHR <- paste("chr",as.character(space(x)),"",sep="")



lMot=1

fdamatrix <- matrix(0.0,ncol=lMot+2*EXT, nrow= length(CHR))   # automate this, length(CHR)



for (i in 1:length(CHR)) {

	CR <- c()
    	cmmd <- paste('./bigWigSummary', paste(FILE[j],".bw",sep=""), CHR[i], as.integer(START[i]), as.integer(END[i]), as.integer(lMot+2*EXT), paste("> tempR_",".txt",sep=args[1]), sep=' ')
    	
	x <- system(cmmd, intern=FALSE);
    	

    	if(length(readLines(paste("tempR_",".txt",sep=args[1])))>0) {   #if no data the file is empty 
#	if(length(x)==1) {

		x <- as.numeric( strsplit(x= readLines(paste("tempR_",".txt",sep=args[1])) ,split="\t")[[1]])

		if(STRAND[i]==1)  { fdamatrix[i,] <- x }        #     as.numeric(strsplit(x=x, split="\t")[[1]]) }
		if(STRAND[i]==-1) { fdamatrix[i,] <- rev(x) }   #     rev(as.numeric(strsplit(x=x, split="\t")[[1]])) }
		#CR <- which( is.na(fdamatrix[i,]) ==TRUE | is.nan(fdamatrix[i,]) ==TRUE  )
		#fdamatrix[i,CR] <- 0.0
#	}
		write.table(i, file = paste("tss_used_",".txt",sep=FILE[j]), append = TRUE, quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)

	}
		
		
	rm(x,CR)
	system(paste("rm",paste("tempR_",".txt",sep=args[1]) ,sep=' '), intern=FALSE);
	


}



# here we have the matrix with all the profiles
# Correct non-numeric values
fdamatrix[which(is.na(fdamatrix)==TRUE)] <- 0.0
fdamatrix[which(is.nan(fdamatrix)==TRUE)] <- 0.0
fdamatrix[which(is.numeric(fdamatrix)==FALSE)] <- 0.0




#library(ggplot2)

#GGP <- data.frame(meanG=as.vector(as.matrix(fdamatrix)), tssG=rep(-EXT:EXT,length(CHR) ))
#c <- ggplot(GGP , aes(tssG, meanG))
##c + stat_smooth()
#c + stat_smooth(fill="blue", colour="darkblue", size=2, alpha = 0.2)+ ggtitle(FILE[j]) +  theme(axis.text = element_text(size = rel(1.8)), axis.title.y = element_text(size = rel(1.8)), axis.title.x = element_text(size = rel(1.8)),plot.title = element_text(size=rel(2.5), face="bold")) + ylab('Smoothed read pileup') + xlab('TSS') + geom_vline(xintercept = 0, linetype=2)
#
#ggsave(paste(FILE[j],".pdf", sep="_ggplot2"))



pdf(file=paste(FILE[j],".pdf", sep=""))

par(mar=c(5,4,4,5)+.1)


library(fda)
bspl <- create.bspline.basis(rangeval=c(-EXT,EXT),nbasis=NB, norder=4)
argvalsBS <- -EXT:EXT
fdaData <- Data2fd(y=t(fdamatrix), argvals= argvalsBS, basisobj=bspl)
#plot(fdaData)  #xlim=c(-EXT-0.5*lMot,0.5*lMot+EXT )


# perform pca
pc<- pca.fd(fdobj=fdaData, nharm = 3, harmfdPar=fdPar(fdaData),centerfns = TRUE)
## plot components
#plot(pc$harmonics, frame=FALSE, cex.lab=1.6,lwd=2, main=FILE[j])
#abline(v=0, lty=4, col="darkgray")

pc<- pca.fd(fdobj=fdaData, nharm = 10, harmfdPar=fdPar(fdaData),centerfns = TRUE)

plot(-EXT:EXT,eval.fd(argvalsBS,pc$meanfd) ,frame=FALSE, type='l', col='black', lwd=2, ylab="Mean", xlab="TSS", cex.lab=1.6,main=FILE[j],cex.main=1.6, cex.axis=1.6, cex.names=1.6 )
#frame=FALSE;colMeans(fdamatrix)


par(new=TRUE)
plot(-EXT:EXT, eval.fd(argvalsBS,pc$harmonics[1]),frame=FALSE ,type="l",col="darkblue",xaxt="n",yaxt="n",xlab="",ylab="", lwd=2, cex.axis=1.6)
axis(4)
mtext(paste(paste("FPC1 (",100*round(pc$varprop[1],3),sep= ""),"%)",sep=""),side=4,line=3, cex=1.6)
legend("topleft",col=c("black","darkblue"),lty=1,legend=c("Mean","FPC1"), bty="n", lwd=3)
abline(v=0, lty=2, col="darkgray", lwd=2)

write.table(t(pc$varprop), file = paste("varprop_", ".txt",sep=FILE[j] ), append = TRUE, quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)

write.table(pc$scores, file = paste("scores_",".txt",sep=FILE[j]), append = FALSE, quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)


par(mar=c(5,4,4,5)+.1)
         
plot(-EXT:EXT,eval.fd(argvalsBS,pc$meanfd),frame=FALSE, type='l', col='black', lwd=2, ylab="Mean", xlab="TSS", cex.lab=1.6,main=FILE[j],cex.main=1.6, cex.axis=1.6, 
cex.names=1.6 )  
#frame=FALSE

par(new=TRUE)
plot(-EXT:EXT, eval.fd(argvalsBS,pc$harmonics[2]),frame=FALSE ,type="l",col="darkred",xaxt="n",yaxt="n",xlab="",ylab="", lwd=2, cex.axis=1.6)
axis(4)
mtext(paste(paste("FPC2 (",100*round(pc$varprop[2],3),sep= ""),"%)",sep=""),side=4,line=3, cex=1.6)
legend("topleft",col=c("black","darkred"),lty=1,legend=c("Mean","FPC2"), bty="n", lwd=3)
abline(v=0, lty=2, col="darkgray", lwd=2)

#3rd component:


par(mar=c(5,4,4,5)+.1)

plot(-EXT:EXT,eval.fd(argvalsBS,pc$meanfd),frame=FALSE, type='l', col='black', lwd=2, ylab="Mean", xlab="TSS", cex.lab=1.6,main=FILE[j],cex.main=1.6, cex.axis=1.6, 
cex.names=1.6 )  
#frame=FALSE

par(new=TRUE)
plot(-EXT:EXT, eval.fd(argvalsBS,pc$harmonics[3]),frame=FALSE ,type="l",col="darkgreen",xaxt="n",yaxt="n",xlab="",ylab="", lwd=2, cex.axis=1.6)
axis(4)
mtext(paste(paste("FPC3 (",100*round(pc$varprop[3],3),sep= ""),"%)",sep=""),side=4,line=3, cex=1.6)
legend("topleft",col=c("black","darkgreen"),lty=1,legend=c("Mean","FPC3"), bty="n", lwd=3)
abline(v=0, lty=2, col="darkgray", lwd=2)

dev.off()


pdf(file=paste(FILE[j],"_3FPCs.pdf", sep=""))

plot(pc$harmonics[1:3],frame=FALSE, lwd=2, ylab="Values", xlab="TSS", cex.lab=1.6,main=FILE[j],cex.main=2, cex.axis=1.6, cex.names=1.6 )
abline(v=0, lty=2, col="darkgray", lwd=2)

dev.off()


#dev.off()



SD <- sd.fd(fdobj=fdaData)
M <- mean.fd(x=fdaData)

Mgg    <- data.frame( mean = c(eval.fd(argvalsBS,M), eval.fd(argvalsBS,M)+ eval.fd(argvalsBS,SD), eval.fd(argvalsBS,M)- eval.fd(argvalsBS,M)), tssG = rep(argvalsBS,3), clase=c(rep("Mean",length(argvalsBS)), rep("SD",2*length(argvalsBS))   ) )

library(ggplot2)

ff <- ggplot(Mgg , aes(tssG, mean))
ff +  geom_line(aes(colour = clase)) + scale_colour_brewer(type="seq",guide=FALSE) + ggtitle(FILE[j])  + ylab('Smoothed read pileup') + xlab('TSS') + geom_vline(xintercept = 0, linetype=2) +  theme(axis.text = element_text(size = rel(1.8)), axis.title.y = element_text(size  = rel(1.8)), axis.title.x = element_text(size = rel(1.8)), plot.title = element_text(size=rel(2.5), face="bold")) + geom_line(data = data.frame( mean = eval.fd(argvalsBS,M),  tssG=argvalsBS)  , colour = "darkblue", size=1.8) 


#Mgg    <- data.frame( mean = eval.fd(argvalsBS,pc$meanfd) , tssG = argvalsBS )
#MggSDp <- data.frame( meanG= eval.fd(argvalsBS,pc$meanfd)+ eval.fd(argvalsBS,SD) , tssG=rep(-EXT:EXT,length(CHR) )) 
#MggSDm <- data.frame( meanG= eval.fd(argvalsBS,pc$meanfd)- eval.fd(argvalsBS,SD) , tssG=rep(-EXT:EXT,length(CHR) ))
#
#library(ggplot2)
#
#ff <- ggplot(Mgg , aes(tssG, mean))
#ff +  geom_line(colour = "darkblue", size = 2) + ggtitle(FILE[j])  + ylab('Smoothed read pileup') + xlab('TSS') + geom_vline(xintercept = 0, linetype=2)
#c +  theme(axis.text = element_text(size = rel(1.8)), axis.title.y = element_text(size  = rel(1.8)), axis.title.x = element_text(size = rel(1.8)), plot.title = element_text(size=rel(2.5), face="bold"))


ggsave(paste(FILE[j],".pdf", sep="_ggplot2"))

#rm(fdaData, bspl, START, END, STRAND, chromos)
#gc(reset=TRUE)
#library(ggplot2)
#GGP <- data.frame(meanG=as.vector(as.matrix(fdamatrix)), tssG=rep(-EXT:EXT,length(CHR) ))
#c <- ggplot(GGP , aes(tssG, meanG))
##c + stat_smooth()
#c + stat_smooth(method="glm", n=100, fill="blue", colour="darkblue", size=2, alpha = 0.2)+ ggtitle(FILE[j]) +  theme(axis.text = element_text(size = rel(1.8)), axis.title.y = element_text(size  = rel(1.8)), axis.title.x = element_text(size = rel(1.8)),plot.title = element_text(size=rel(2.5), face="bold")) + ylab('Smoothed read pileup') + xlab('TSS') + geom_vline(xintercept = 0, linetype=2)
#ggsave(paste(FILE[j],".pdf", sep="_ggplot2"))

 }
 






