
#Compute-pair wise correlations of scores, and
#report (1) the maximum, (2) the order of the components, and (3) correlation of eigenfunctions for these components

#FPCcorrelation.r

#n=$(ls *pc_scores.txt )
#Rscript FPCcorrelation.r $(echo $n)

#library(Matrix)

args<-commandArgs(TRUE);

#args <- c("H3K4me1","H3K4me2", "H3K4me3")
#number of samples
N <- length(args)

I <-c()
J <- c()

MAXCORSCORES  <- matrix(1.0,nrow=N, ncol=N)
POSMAX        <- matrix(NA,nrow=N, ncol=N)
COREIGENF     <- matrix(1.0,nrow=N, ncol=N)

for(i in 1:N){
  for(j in 1:N){
    
    I[i] <- strsplit( as.character(args[i]), split="_")[[1]][1]
    J[j] <- strsplit( as.character(args[j]), split="_")[[1]][1]
    
    x <- paste( I[i] , "H1_pc_scores.txt", sep="_")
    y <- paste( J[j],  "H1_pc_scores.txt", sep="_")
    X <- as.matrix(read.table(x, head=F))
    Y <- as.matrix(read.table(y, head=F))
    
    xcomp <- paste( I[i] , "H1_pc_components.txt", sep="_")
    ycomp <- paste( J[j] , "H1_pc_components.txt", sep="_")
    Xcomp <- as.matrix(read.table(xcomp, head=F))
    Ycomp <- as.matrix(read.table(ycomp, head=F))
    
    #For all the components (D) between X and Y:
    if ( ncol(X) == ncol(Y)) {
      
      D <- ncol(X)
      #Pearson corr matrix
      CORREL <- matrix(0.0, ncol=D, nrow=D)
      
      for(l in 1:D){
        for(m in 1:D){
          CORREL[l,m] <- cor(x =X[,l] , y =Y[,m] , method="pearson")          
        }
      }            
    }
    
    if (i!=j){
      #Save position
      POSMAX[i,j] <- paste( which(abs(CORREL) == max(abs(CORREL)), arr.ind = TRUE)[1,1:2], collapse=",") 
      #Save corr of eigenfunctions  
      row <- which(abs(CORREL) == max(abs(CORREL)), arr.ind = TRUE)[1,1]
      col <- which(abs(CORREL) == max(abs(CORREL)), arr.ind = TRUE)[1,2]
      COREIGENF[i,j]    <- cor(Xcomp[row,],Ycomp[col,])
      #Save max corr of scores
      MAXCORSCORES[i,j] <- CORREL[row,col] #signed
    
  
      #Print info in terminal---------------------------------------------------------------
      print(paste(rep("-",40),collapse=""))
      print(paste(I[i],J[j], sep="-"))
      print("Max corr of scores:")
      print( MAXCORSCORES[i,j] )
      print("Pos Max corr of scores (row,col):")
      print(  POSMAX[i,j]   )
      print("corr of eigenfunctions:")
      print( COREIGENF[i,j]  )
      print(paste(rep("-",40),collapse=""))
      #------------------------------------------------------------------------------------
    }
    
  }
}

#Write output files

rownames(MAXCORSCORES) <- I
colnames(MAXCORSCORES) <- J
write.csv(x=MAXCORSCORES, file = "cor_Scores.csv")

rownames(POSMAX) <- I
colnames(POSMAX) <- J
write.csv(x=POSMAX, file = "cor_Scores_#Eigenfunctions.csv")

rownames(COREIGENF) <- I
colnames(COREIGENF) <- J
write.csv(x=COREIGENF, file = "cor_Eigenfunctions.csv")




