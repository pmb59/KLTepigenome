#4 changes
#Function to plot cumulative proportion of variance

args<-commandArgs(TRUE);

N <- length(args)
#L <- length(t( read.table( paste(as.character(args[1]),"varprop.txt",sep="_") )  ))
L <- length(t( read.table( as.character(args[1]) )  ))
#print(N)
#print(L)


library(RColorBrewer)
if (N<3) { cl <- colorRampPalette(brewer.pal(3,"Dark2"))(3) }  #equal number 
if (N>=3) {cl <- colorRampPalette(brewer.pal(N,"Dark2"))(N) } #equal number

lt <- 1

LG <- c()
for (k in 1:length(args)){LG[k] <- strsplit(x=args[k],split="_" )[[1]][1] }
#print(LG)
Titl <- paste(strsplit(x=args[1],split="_" )[[1]][2:3],sep="-")

pdf(file="propVarPlotgit.pdf", width=5, height=5)


plot(1:L,100*cumsum(t(read.table( as.character(args[1])))), type='l', col=cl[1], xlab="Component", ylab="Cumulative sum (%)", main=Titl,lwd=2,ylim=c(0,100),lty=lt, log = "x")

for (j in 2:N){
  points(1:L,100*cumsum(t(read.table(as.character(args[j])))), type='l', col=cl[j],lwd=2,lty=lt, log = "x")
  
}
legend("bottomright",legend=LG, col=cl, bty='n', lty=lt, cex=1, lwd=2)



