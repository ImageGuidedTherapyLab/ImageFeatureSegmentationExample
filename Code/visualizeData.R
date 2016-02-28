#  Usage:
#   > source('Code/visualizeData.R')
library( ANTsR )
library( randomForest )
library( snowfall )
library( rlecuyer )
#rm(list=ls())

options("width"=200)
stopQuietly <- function(...)
  {
  blankMsg <- sprintf( "\r%s\r", paste( rep(" ", getOption( "width" ) - 1L ), collapse = " ") );
  stop( simpleError( blankMsg ) );
  } # stopQuietly()

args <- commandArgs( trailingOnly = TRUE )
args <- c( "3","workdir")

###############################################
#
# Selected parameters
#
###############################################

if( length( args ) < 2 )
  {
  cat( "Usage: Rscript createModel.R dimension inputFileList " , sep = "" )
  stopQuietly()
  }

dimension      <- as.numeric(   args[1] )
workDirectory  <- as.character( args[2] )
inputCSVFile      = paste( workDirectory, "/visualizeData.csv", sep = "")
outputDataCSVFile = paste( workDirectory, "/TopPredictors.csv", sep = "")
outputDataPDFFile = paste( workDirectory, "/StatSummary.pdf", sep = "")

fileList  <- read.csv( inputCSVFile   ,header=FALSE)

###############################################
#
# concat all data frames 
#
###############################################

modelData <- matrix()
for( jfile in 1:length( fileList ) )
  {
  cat( "  Reading feature image ", as.character(fileList[1,jfile]), ".\n", sep = "" )
  load(as.character(fileList [1,jfile]) )                               
  print( colnames( subjectData ))
  print(head(subjectData ,n=10))
  if( jfile == 1 )
    {
    modelData  <- data.frame(subjectData) 
    }
  else
    {
    modelData <- rbind( modelData, 
                        data.frame(subjectData )
                      )
    }
  }
print(paste("rows ",nrow( modelData )," col",ncol( modelData )))
#colnames( modelData ) <- colnames( subjectData ) 
#modelData <- as.data.frame( modelData )
#modelData$Labels <- as.factor( modelData$Labels )

# compute p-values
print( "compute predictors ...  ")
normalsubset   = subset(modelData, Labels == 1 )
viablesubset   = subset(modelData, Labels == 2 )
necrosissubset = subset(modelData, Labels == 3 )

featureNames <- colnames( modelData )
featureNames <- featureNames[1:(length(featureNames)-2)]

numtests= 2
normalviablepvalue    <- matrix( NA, nrow = numtests, ncol = length( featureNames ) )
normalnecrosispvalue  <- matrix( NA, nrow = numtests, ncol = length( featureNames ) )
necrosisviablepvalue  <- matrix( NA, nrow = numtests, ncol = length( featureNames ) )
tissuekruskalpvalue   <- matrix( NA, nrow = 1       , ncol = length( featureNames ) )
colnames( tissuekruskalpvalue  ) <- c( featureNames)
colnames( normalviablepvalue   ) <- c( featureNames)
colnames( normalnecrosispvalue ) <- c( featureNames)
colnames( necrosisviablepvalue ) <- c( featureNames)

for (iii in 1:length(featureNames))
{
  print(featureNames[iii] )
  normalviablettest    =      try(t.test( normalsubset[[featureNames[iii]]],   viablesubset[[featureNames[iii]]]))
  #normalnecrosisttest  =      t.test( normalsubset[[featureNames[iii]]], necrosissubset[[featureNames[iii]]])
  #necrosisviablettest  =      t.test( viablesubset[[featureNames[iii]]], necrosissubset[[featureNames[iii]]])
  normalviablewilcox   = try(wilcox.test( normalsubset[[featureNames[iii]]],   viablesubset[[featureNames[iii]]]))

  #normalnecrosiswilcox = wilcox.test( normalsubset[[featureNames[iii]]], necrosissubset[[featureNames[iii]]])
  #necrosisviablewilcox = wilcox.test( viablesubset[[featureNames[iii]]], necrosissubset[[featureNames[iii]]])
  #tissuekruskaltest    =     kruskal.test( subjectData[[featureNames[iii]]], subjectData$Labels)

  print( normalviablettest   )
  #print( normalnecrosisttest )
  #print( necrosisviablettest )
  print( normalviablewilcox  )
  #print( normalnecrosiswilcox)
  #print( necrosisviablewilcox)
  #print( tissuekruskaltest   )

  #tissuekruskalpvalue[ 1,iii]  =   2*dchisq(tissuekruskaltest$statistic, tissuekruskaltest$parameter,log=TRUE)
  
  if (is(normalviablettest, "try-error")){normalviablepvalue[  1,iii] =NA}else{normalviablepvalue[  1,iii]  =   2*pt( -abs(   normalviablettest$statistic), df=   normalviablettest$parameter,log=TRUE)}
  #normalnecrosispvalue[1,iii]  =   2*pt( -abs( normalnecrosisttest$statistic), df= normalnecrosisttest$parameter,log=TRUE)
  #necrosisviablepvalue[1,iii]  =   2*pt( -abs( necrosisviablettest$statistic), df= necrosisviablettest$parameter,log=TRUE)
  
  if (is(normalviablewilcox, "try-error")){normalviablepvalue[  2,iii]=NA}else{normalviablepvalue[  2,iii]=normalviablewilcox$p.value}
  #normalnecrosispvalue[2,iii]  =              normalnecrosiswilcox$p.value
  #necrosisviablepvalue[2,iii]  =              necrosisviablewilcox$p.value
}

#variableimportance = normalviablepvalue + normalnecrosispvalue + necrosisviablepvalue

#print( sort(variableimportance[  1,])[1:20] )
print( sort(normalviablepvalue[  1,])[1:20] )
#print( sort(normalnecrosispvalue[1,])[1:20] )
#print( sort(necrosisviablepvalue[1,])[1:20] )
#print( sort(tissuekruskalpvalue[ 1,])[1:20] )

# save top predictors
# FIXME - format
toppredictors <- sort(normalviablepvalue[  1,])[1:20] 
write.csv( toppredictors  , file = outputDataCSVFile )
predictornames = names(toppredictors)

## #color code
## colcode <- character(nrow(qoisubset))
## colcode[] <- "black"
## colcode[qoisubset$dirmethod == 'GR'] <- 1
## colcode[qoisubset$dirmethod == 'S2'] <- 3
## 
## symcode <- integer(nrow(qoisubset))
## symcode[qoisubset$dirmethod == 'GR'] <- 1
## symcode[qoisubset$dirmethod == 'S2'] <- 3


# lexical scope on color code and symbol code
# http://www.johndcook.com/R_language_for_programmers.html#scope
## put histograms on the diagonal
panel.summaryhist <- function(x, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(usr[1:2], 0, 2.5) )
    h <- hist(x, plot = FALSE)
    breaks <- h$breaks; nB <- length(breaks)
    y <- h$counts; y <- y/max(y)
    rect(breaks[-nB], 0, breaks[-1], y, col='cyan', ...)
    meanvalue <- mean(x)
    localdigits <- 4
    avgtxt <- paste("avg=", format( meanvalue , digits = localdigits ))
    stdtxt <- paste("std=", format( sd(x)     , digits = localdigits ))
    mintxt <- paste("min=", format( min(x)    , digits = localdigits ))
    maxtxt <- paste("max=", format( max(x)    , digits = localdigits ))
    text(meanvalue , 1.2, mintxt )
    text(meanvalue , 1.4, avgtxt )
    text(meanvalue , 1.6, stdtxt )
    text(meanvalue , 1.8, maxtxt )
    #if (do.legend) legend(43,2.5,c("GR","S2"), col = c(1,3), pch = c(1,3), bg="white")
    do.legend <<- FALSE
  
}
## put (absolute) correlations on the upper panels,
## with size proportional to the correlations.
panel.summarycor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(0, 1, 0, 1))
    r <- abs(cor(x, y))
    txt <- format(c(r, 0.123456789), digits = digits)[1]
    if(cor(x, y) <  0.0) txt <- paste("cor=-", txt)
    if(cor(x, y) >= 0.0) txt <- paste("cor=" , txt)
    if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
    #text(0.5, 0.5, txt, cex = cex.cor * r)
    text(0.5, 0.5, txt, cex = 3.0* r)
}

# lexical scope on color code and symbol code
# http://www.johndcook.com/R_language_for_programmers.html#scope
panel.summarylinear <- function(x, y)
{
        points(x,y)
        #points(x,y,col=colcode,pch=symcode)
	abline(lm(y~x), col='red')
        #abline(h=CrossOver,v=CrossOver,col='blue',lty=2)
}

#color code
numberOfUniqueLabels = 2
colcode <- character(numberOfUniqueLabels)
colcode[1] <- "red"
colcode[2] <- "green"
colcode[3] <- "blue"
colcode[4] <- "yellow"
# lexical scope on color code and symbol code
# http://www.johndcook.com/R_language_for_programmers.html#scope
## put histograms on the diagonal
panel.hist <- function(x, ...)
{
    ## Calculate and plot the two histograms
    usr <- par("usr"); on.exit(par(usr))

    maxden = 0 
    for (iii in 1:numberOfUniqueLabels) {
       densitylist <- density(x[modelData$Labels==(iii)])
       maxden = max(maxden,max(densitylist$y))
    }
    
    par(usr = c(usr[1:2], 0, maxden  ))
    for (iii in 1:numberOfUniqueLabels) {
       densitylist <- density(x[modelData$Labels==(iii)])
       lines(densitylist,col=colcode[iii])
    }

}
## put (absolute) correlations on the upper panels,
## with size proportional to the correlations.
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(0, 1, 0, 1))
    r <- abs(cor(x, y))
    txt <- format(c(r, 0.123456789), digits = digits)[1]
    if(cor(x, y) <  0.0) txt <- paste("cor=-", txt)
    if(cor(x, y) >= 0.0) txt <- paste("cor=" , txt)
    if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
    #text(0.5, 0.5, txt, cex = cex.cor * r)
    text(0.5, 0.5, txt, cex = 3.0* r)
}

# lexical scope on color code and symbol code
# http://www.johndcook.com/R_language_for_programmers.html#scope
panel.linear <- function(x, y,...)
{
        #points(x,y,col=colcode,pch=symcode)
        #bin <- hexbin(x,y,xbins=50)
        #plot(bin)
        #points(x,y)
	#abline(lm(y~x), col='red')
        #abline(h=CrossOver,v=CrossOver,col='blue',lty=2)
    for (iii in 1:numberOfUniqueLabels) {
     zzz = kde2d(x[modelData$Labels==(iii)],y[modelData$Labels==(iii)])
     conlin = contourLines(zzz$x,zzz$x, zzz$z,nlevels=7)
     for (jjj in 1:length(conlin) ) {
       lines(conlin[[jjj]],col=colcode[iii])
     }
    }
}



## plot 
## do.legend <- TRUE
pdf(outputDataPDFFile )
pairs(~get(predictornames[1])+get(predictornames[2])+get(predictornames[3])+get(predictornames[4])+get(predictornames[5]),data=modelData,
        diag.panel  = panel.hist, 
        lower.panel = panel.linear,
        upper.panel = panel.cor,
        #xlim = c(-10.,210.),
        #ylim = c(-10.,210.)
      )
dev.off()



### ## plot 
### ## do.legend <- TRUE
### pdf(paste('pdffig/Stats','Norm','.pdf',sep=""))
###  pairs(~T1Norm+T2Norm+FLNorm+TCNorm,data=modelData,
###         diag.panel  = panel.hist, 
###         lower.panel = panel.linear,
###         upper.panel = panel.cor,
###         #xlim = c(-10.,210.),
###         #ylim = c(-10.,210.)
###       )
### dev.off()
### ## plot 
### ## do.legend <- TRUE
### pdf(paste('pdffig/Stats','Bias','.pdf',sep=""))
###  pairs(~T1Bias+T2Bias+FLBias+TCBias,data=modelData,
###         diag.panel  = panel.hist, 
###         lower.panel = panel.linear,
###         upper.panel = panel.cor,
###         #xlim = c(-10.,210.),
###         #ylim = c(-10.,210.)
###       )
### dev.off()
### ## plot 
### ## do.legend <- TRUE
### pdf(paste('pdffig/Stats','Anat0','.pdf',sep=""))
###  pairs(~T1Anat0+T2Anat0+FLAnat0+TCAnat0,data=modelData,
###         diag.panel  = panel.hist, 
###         lower.panel = panel.linear,
###         upper.panel = panel.cor,
###         #xlim = c(-10.,210.),
###         #ylim = c(-10.,210.)
###       )
### dev.off()
### ## plot 
### ## do.legend <- TRUE
### pdf(paste('pdffig/Stats','Anat1','.pdf',sep=""))
###  pairs(~T1Anat1+T2Anat1+FLAnat1+TCAnat1,data=modelData,
###         diag.panel  = panel.hist, 
###         lower.panel = panel.linear,
###         upper.panel = panel.cor,
###         #xlim = c(-10.,210.),
###         #ylim = c(-10.,210.)
###       )
### dev.off()
### ## plot 
### ## do.legend <- TRUE
### pdf(paste('pdffig/Stats','Anat2','.pdf',sep=""))
###  pairs(~T1Anat2+T2Anat2+FLAnat2+TCAnat2,data=modelData,
###         diag.panel  = panel.hist, 
###         lower.panel = panel.linear,
###         upper.panel = panel.cor,
###         #xlim = c(-10.,210.),
###         #ylim = c(-10.,210.)
###       )
### dev.off()
### ## plot 
### ## do.legend <- TRUE
### pdf(paste('pdffig/Stats','Anat3','.pdf',sep=""))
###  pairs(~T1Anat3+T2Anat3+FLAnat3+TCAnat3,data=modelData,
###         diag.panel  = panel.hist, 
###         lower.panel = panel.linear,
###         upper.panel = panel.cor,
###         #xlim = c(-10.,210.),
###         #ylim = c(-10.,210.)
###       )
### dev.off()
