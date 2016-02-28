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
args <- c( "3","./visualizeData.csv")

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

dimension <- as.numeric( args[1] )
fileList  <- read.csv( args[2] ,header=FALSE)

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


### patientid          <- fileList[,1]
### pathology          <- fileList[,2]
### masks              <- fileList[,3]
### gmmLabels          <- fileList[,4]
### featureImages      <- fileList[,5:ncol( fileList )]   # raw images included 
### featureNames       <- colnames( featureImages )
### 
### totalNumberOfImages <- length( masks )
### trainingPortion <- 1.0
### modelNumberOfSubjects <- floor( trainingPortion * totalNumberOfImages )
### numberOfUniqueLabels <- 2
### numberOfSamplesPerLabel <- 1000
### 
### 
### ## #color code
### ## colcode <- character(nrow(qoisubset))
### ## colcode[] <- "black"
### ## colcode[qoisubset$dirmethod == 'GR'] <- 1
### ## colcode[qoisubset$dirmethod == 'S2'] <- 3
### ## 
### ## symcode <- integer(nrow(qoisubset))
### ## symcode[qoisubset$dirmethod == 'GR'] <- 1
### ## symcode[qoisubset$dirmethod == 'S2'] <- 3
### 
### 
### # lexical scope on color code and symbol code
### # http://www.johndcook.com/R_language_for_programmers.html#scope
### ## put histograms on the diagonal
### panel.summaryhist <- function(x, ...)
### {
###     usr <- par("usr"); on.exit(par(usr))
###     par(usr = c(usr[1:2], 0, 2.5) )
###     h <- hist(x, plot = FALSE)
###     breaks <- h$breaks; nB <- length(breaks)
###     y <- h$counts; y <- y/max(y)
###     rect(breaks[-nB], 0, breaks[-1], y, col='cyan', ...)
###     meanvalue <- mean(x)
###     localdigits <- 4
###     avgtxt <- paste("avg=", format( meanvalue , digits = localdigits ))
###     stdtxt <- paste("std=", format( sd(x)     , digits = localdigits ))
###     mintxt <- paste("min=", format( min(x)    , digits = localdigits ))
###     maxtxt <- paste("max=", format( max(x)    , digits = localdigits ))
###     text(meanvalue , 1.2, mintxt )
###     text(meanvalue , 1.4, avgtxt )
###     text(meanvalue , 1.6, stdtxt )
###     text(meanvalue , 1.8, maxtxt )
###     #if (do.legend) legend(43,2.5,c("GR","S2"), col = c(1,3), pch = c(1,3), bg="white")
###     do.legend <<- FALSE
###   
### }
### ## put (absolute) correlations on the upper panels,
### ## with size proportional to the correlations.
### panel.summarycor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
### {
###     usr <- par("usr"); on.exit(par(usr))
###     par(usr = c(0, 1, 0, 1))
###     r <- abs(cor(x, y))
###     txt <- format(c(r, 0.123456789), digits = digits)[1]
###     if(cor(x, y) <  0.0) txt <- paste("cor=-", txt)
###     if(cor(x, y) >= 0.0) txt <- paste("cor=" , txt)
###     if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
###     #text(0.5, 0.5, txt, cex = cex.cor * r)
###     text(0.5, 0.5, txt, cex = 3.0* r)
### }
### 
### # lexical scope on color code and symbol code
### # http://www.johndcook.com/R_language_for_programmers.html#scope
### panel.summarylinear <- function(x, y)
### {
###         points(x,y)
###         #points(x,y,col=colcode,pch=symcode)
### 	abline(lm(y~x), col='red')
###         #abline(h=CrossOver,v=CrossOver,col='blue',lty=2)
### }
### 
### ###############################################################################################
### ## Create the model data frame
### modelData <- data.frame()
### indices <- sort( sample.int( totalNumberOfImages, modelNumberOfSubjects, replace = FALSE ) )
### for( i in indices )
###   {
###   cat( as.character( gmmLabels[i] ), "\n" )
###   maskfilename = paste( 'workdir/',pathology[i],'/',patientid[i],'/',masks[i],sep="")
###   mask <- as.array( antsImageRead( maskfilename  , dimension = dimension, pixeltype = 'unsigned int' ) )
###   gmmfilename = paste( 'workdir/',pathology[i],'/',patientid[i],'/',gmmLabels[i],sep="")
###   truth <- as.array( antsImageRead( gmmfilename , dimension = dimension, pixeltype = 'unsigned int' ) )
###   if( is.na( numberOfUniqueLabels ) )
###     {
###     uniqueTruthLabels <- sort( unique( truth[which( mask == 1 )] ) )
###     uniqueTruthLabels <- uniqueTruthLabels[which( uniqueTruthLabels != 0 )]
###     }
###   else
###     {
###     uniqueTruthLabels <- 1:numberOfUniqueLabels
###     }
###   cat( "Unique truth labels: ", uniqueTruthLabels, "\n", sep = " " )
### 
###   truthLabelIndices <- list()
###   numberOfSamplesPerLabelInSubjectData <- rep( 0, length( uniqueTruthLabels ) )
###   for( n in 1:length( uniqueTruthLabels ) )
###     {
###     labelIndices <- which( truth == uniqueTruthLabels[n] )
###     numberOfSamplesPerLabelInSubjectData[n] <- min( numberOfSamplesPerLabel, length( labelIndices ) )
###     if( length( labelIndices ) > 0 )
###       {
###       truthLabelIndices[[n]] <- labelIndices[sample.int( length( labelIndices ), numberOfSamplesPerLabelInSubjectData[n], replace = FALSE )]
###       }
###     }
### 
###   subjectData       <- matrix( NA, nrow = sum( numberOfSamplesPerLabelInSubjectData ), ncol = length( featureNames ) +2 )
###   for( j in 1:length( featureNames ) )
###     {
###     cat( "  Reading feature image ", featureNames[j], ".\n", sep = "" )
###     featureImagefilename = paste( 'workdir/',pathology[i],'/',patientid[i],'/',featureImages[i,j],sep="")
###     featureImage <- as.array( antsImageRead( featureImagefilename , dimension = dimension, pixeltype = 'float' ) )
###     for( n in 1:length( uniqueTruthLabels ) )
###       {
###       if( numberOfSamplesPerLabelInSubjectData[n] == 0 )
###         {
###         next
###         }
### 
###       values <- featureImage[truthLabelIndices[[n]]]
### 
###       startIndex <- 1
###       if( n > 1 )
###         {
###         startIndex <- sum( numberOfSamplesPerLabelInSubjectData[1:(n-1)] ) + 1
###         }
###       endIndex <- startIndex + length( values ) - 1
### 
###       subjectData[startIndex:endIndex, j] <- values
###       if( j == 1 )
###         {
###         labeloffset = 0
###          subjectData[startIndex:endIndex,length( featureNames )+ 1] <- rep.int( uniqueTruthLabels[n] + labeloffset        , length( truthLabelIndices[[n]] ) )
###         #subjectData[startIndex:endIndex, 2] <- rep.int( voldata$Vol[which( voldata$LabelID == n )], length( truthLabelIndices[[n]] ) )
###          subjectData[startIndex:endIndex,length( featureNames )+ 2] <- rep.int(   0                                       , length( truthLabelIndices[[n]] ) )
###         }
###       }
###     }
###   if( i == indices[1] )
###     {
###     modelData  <- data.frame(subjectData , contrast=rep(pathology[i] ,sum( numberOfSamplesPerLabelInSubjectData )))
###     }
###   else
###     {
###     modelData <- rbind( modelData,
###                   data.frame(subjectData , contrast=rep(pathology[i] ,sum( numberOfSamplesPerLabelInSubjectData )))
###                       )
###     }
###   }
### colnames( modelData  ) <- c( featureNames, "Labels" , "Volume", "Pathology" )
### #modelData         <- as.data.frame( modelData        )
### modelData$Labels  <- as.factor(     modelData$Labels )
### 
### #a <- matrix( 0, nrow = 3, ncol = 2 )
### #c <- cbind(a,rep("train1",3))
### #b <- data.frame(a , mrn=rep("train1",3))
### 
### 
### # view first 10 lines
### print(head(modelData ,n=10))
### 
### # print columns
### names(modelData )
### 
### 
### #color code
### colcode <- character(numberOfUniqueLabels)
### colcode[1] <- "red"
### colcode[2] <- "green"
### colcode[3] <- "blue"
### colcode[4] <- "yellow"
### # lexical scope on color code and symbol code
### # http://www.johndcook.com/R_language_for_programmers.html#scope
### ## put histograms on the diagonal
### panel.hist <- function(x, ...)
### {
###     ## Calculate and plot the two histograms
###     usr <- par("usr"); on.exit(par(usr))
### 
###     maxden = 0 
###     for (iii in 1:numberOfUniqueLabels) {
###        densitylist <- density(x[modelData$Labels==(iii)])
###        maxden = max(maxden,max(densitylist$y))
###     }
###     
###     par(usr = c(usr[1:2], 0, maxden  ))
###     for (iii in 1:numberOfUniqueLabels) {
###        densitylist <- density(x[modelData$Labels==(iii)])
###        lines(densitylist,col=colcode[iii])
###     }
### 
### }
### ## put (absolute) correlations on the upper panels,
### ## with size proportional to the correlations.
### panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
### {
###     usr <- par("usr"); on.exit(par(usr))
###     par(usr = c(0, 1, 0, 1))
###     r <- abs(cor(x, y))
###     txt <- format(c(r, 0.123456789), digits = digits)[1]
###     if(cor(x, y) <  0.0) txt <- paste("cor=-", txt)
###     if(cor(x, y) >= 0.0) txt <- paste("cor=" , txt)
###     if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
###     #text(0.5, 0.5, txt, cex = cex.cor * r)
###     text(0.5, 0.5, txt, cex = 3.0* r)
### }
### 
### # lexical scope on color code and symbol code
### # http://www.johndcook.com/R_language_for_programmers.html#scope
### panel.linear <- function(x, y,...)
### {
###         #points(x,y,col=colcode,pch=symcode)
###         #bin <- hexbin(x,y,xbins=50)
###         #plot(bin)
###         #points(x,y)
### 	#abline(lm(y~x), col='red')
###         #abline(h=CrossOver,v=CrossOver,col='blue',lty=2)
###     for (iii in 1:numberOfUniqueLabels) {
###      zzz = kde2d(x[modelData$Labels==(iii)],y[modelData$Labels==(iii)])
###      conlin = contourLines(zzz$x,zzz$x, zzz$z,nlevels=7)
###      for (jjj in 1:length(conlin) ) {
###        lines(conlin[[jjj]],col=colcode[iii])
###      }
###     }
### }
### 
### ## plot 
### ## do.legend <- TRUE
### pdf(paste('pdffig/Stats','Raw','.pdf',sep=""))
###  pairs(~T1Raw+T2Raw+FLRaw+TCRaw,data=modelData,
###         diag.panel  = panel.hist, 
###         lower.panel = panel.linear,
###         upper.panel = panel.cor,
###         #xlim = c(-10.,210.),
###         #ylim = c(-10.,210.)
###       )
### dev.off()
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
