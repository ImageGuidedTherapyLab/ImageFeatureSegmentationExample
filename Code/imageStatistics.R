#  Usage:
#   > source('Code/imageStatistics.R')
library( ANTsR )
library( randomForest )
library( snowfall )

stopQuietly <- function(...)
  {
  blankMsg <- sprintf( "\r%s\r", paste( rep(" ", getOption( "width" ) - 1L ), collapse = " ") );
  stop( simpleError( blankMsg ) );
  } # stopQuietly()

args <- commandArgs( trailingOnly = TRUE )
#args <- c( "3","./workdir/Predict1001/before/FullImageList.csv","./workdir/Predict1001/before/")
#args <- c( "3","workdir/Predict1002/01012000/FullImageList.csv","workdir/Predict1002/01012000")
 


###############################################
#
# Selected parameters
#
###############################################

if( length( args ) < 3 )
  {
  cat( "Usage: Rscript imageStatistics.R dimension inputCSVFile ",
       "outputProbabilityImagePrefix <numberOfThreads=4>", sep = "" )
  stopQuietly()
  }

dimension <- as.numeric( args[1] )
fileList <- read.csv( args[2] )
outputDataFileBase <- args[3]
outputDataFileName = paste( outputDataFileBase, "/ImageData.Rdata", sep = "")
outputDataCSVFile  = paste( outputDataFileBase, "/TopPredictors.csv", sep = "")

###############################################
#
# Put the image data into a data frame (subjectData)
#
###############################################

maskName      <- fileList[1,1]
truthName     <- fileList[1,2]
featureImages <- fileList[1,3:ncol( fileList )]
featureNames  <- colnames( featureImages )

## read mask
maskImage <- antsImageRead( as.character( maskName ), dimension = dimension, pixeltype = 'unsigned int' )
mask <- as.array( maskImage )
maskIndices <- which( mask != 0 )

## load feature images
subjectData <- matrix( NA, nrow = length( maskIndices ), ncol = length( featureNames )+1 )
for( j in 1:length( featureNames ) )
  {
  cat( "  Reading feature image ", featureNames[j], ".\n", sep = "" )
  featureImage <- as.array( antsImageRead( as.character( featureImages[1,j] ), dimension = dimension, pixeltype = 'float' ) )

  values <- featureImage[maskIndices]
  subjectData[, j] <- values
  }

## read labels
truthImage <- as.array( antsImageRead( as.character( truthName ), dimension = dimension, pixeltype = 'unsigned int' ) )
uniqueTruthLabels <- sort( unique( truthImage[maskIndices] ) )
cat( "Unique truth labels: ", uniqueTruthLabels, "\n", sep = " " )
subjectData[, length( featureNames )+1] <- truthImage[maskIndices]
colnames( subjectData ) <- c( featureNames, "Labels" )

# If the subject data has NA's, we need to get rid of them
# since predict.randomForest will return NA's otherwise.
# Setting NA's to 0 is a complete hack.
print( "cleaning up ...  ")
subjectData[is.na( subjectData )] <- 0

print( "formatting ...  ")
subjectData        <- as.data.frame( subjectData )
subjectData$Labels <- as.factor(     subjectData$Labels )
print(head(subjectData,n=10))

# FIXME filter zero's
print( "saving ...  ")
save( subjectData, file = outputDataFileName)
cat("File size (MB):",round(file.info(outputDataFileName)$size/1024^2),"\n")

# compute p-values
print( "compute predictors ...  ")
normalsubset   = subset(subjectData, Labels == 1 )
viablesubset   = subset(subjectData, Labels == 2 )
necrosissubset = subset(subjectData, Labels == 3 )

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
  normalviablettest    =      t.test( normalsubset[[featureNames[iii]]],   viablesubset[[featureNames[iii]]])
  #normalnecrosisttest  =      t.test( normalsubset[[featureNames[iii]]], necrosissubset[[featureNames[iii]]])
  #necrosisviablettest  =      t.test( viablesubset[[featureNames[iii]]], necrosissubset[[featureNames[iii]]])
  normalviablewilcox   = wilcox.test( normalsubset[[featureNames[iii]]],   viablesubset[[featureNames[iii]]])
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
  normalviablepvalue[  1,iii]  =   2*pt( -abs(   normalviablettest$statistic), df=   normalviablettest$parameter,log=TRUE)
  #normalnecrosispvalue[1,iii]  =   2*pt( -abs( normalnecrosisttest$statistic), df= normalnecrosisttest$parameter,log=TRUE)
  #necrosisviablepvalue[1,iii]  =   2*pt( -abs( necrosisviablettest$statistic), df= necrosisviablettest$parameter,log=TRUE)
  normalviablepvalue[  2,iii]  =                normalviablewilcox$p.value
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

#sort(normalviablepvalue[  2,],decreasing=TRUE)
#sort(normalnecrosispvalue[2,],decreasing=TRUE)
#sort(necrosisviablepvalue[2,],decreasing=TRUE)


# t.test( viablesubset$Ven_SKEWNESS_RADIUS_3, necrosissubset$Ven_SKEWNESS_RADIUS_3)
# xxx = t.test( viablesubset$Del_SKEWNESS_RADIUS_5, necrosissubset$Del_SKEWNESS_RADIUS_5)
# pvalue = dt(xxx$statistic, df=xxx$parameter,log=TRUE)



## ## Hollander & Wolfe (1973), 116.
## ## Mucociliary efficiency from the rate of removal of dust in normal
## ##  subjects, subjects with obstructive airway disease, and subjects
## ##  with asbestosis.
## x <- c(2.9, 3.0, 2.5, 2.6, 3.2) # normal subjects
## y <- c(3.8, 2.7, 4.0, 2.4)      # with obstructive airway disease
## z <- c(2.8, 3.4, 3.7, 2.2, 2.0) # with asbestosis
## kruskal.test(list(x, y, z))
## ## Equivalently,
## x <- c(x, y, z)
## g <- factor(rep(1:3, c(5, 4, 5)),
##             labels = c("Normal subjects",
##                        "Subjects with obstructive airway disease",
##                        "Subjects with asbestosis"))
## xxx = kruskal.test(x, g)
## print(xxx)
## dchisq(xxx$statistic, xxx$parameter)
## 




## > t.test(1:10, y = c(7:20, 200))
## 
##         Welch Two Sample t-test
## 
## data:  1:10 and c(7:20, 200)
## t = -1.6329, df = 14.165, p-value = 0.1245
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -47.242900   6.376233
## sample estimates:
## mean of x mean of y
##   5.50000  25.93333
## 
## > yyy = t.test(1:10, y = c(7:20, 200))
## > 2*pt(yyy$statistic, df=yyy$parameter)
##         t
## 0.1245135
## > 2*pt(yyy$statistic, df=yyy$parameter,log=TRUE)
##         t
## -5.552977



#  http://www.stat.columbia.edu/~martin/W2024/R2.pdf

#  
#  Since the p-value is very low, we reject the null hypothesis.
#  

## ##
## ##   Compute p-values
## ##
## ##  https://stat.ethz.ch/pipermail/r-help/2008-August/170453.html
## ##
## ## ## On 09-Aug-08 20:31:33, Felipe Carrillo wrote:
## ## ## ># Hi all:
## ## ## >      #I got a vector with fish lengths(mm)
## ## ## >      # Can someone help me interpret the output of
## ## ## >      # a t.test in plain english?
## ## ## >      #  Based on the t.test below I can say that
## ## ## >      # I reject the null hypothesis because
## ## ## >      # the p-value is smaller than the the significance
## ## ## >      # level(alpha=0.05). What else can I conclude here?
## ## ## >     Ho = 36 mm
## ## ## >     Ha <> 36 mm
## ## ## >     fishlength <- c(35,32,37,39,42,45,37,36,35,34,40,42,41,50)
## ## ## >     t.test(fishlength,mu=36)
## ## ## >        One Sample t-test
## ## ## >
## ## ## > data:  fishlength
## ## ## > t = 2.27, df = 13, p-value = 0.04087
## ## ## > alternative hypothesis: true mean is not equal to 36
## ## ## > 95 percent confidence interval:
## ## ## >  36.14141 41.71573
## ## ## > sample estimates:
## ## ## > mean of x
## ## ## >  38.92857
## ## ##
## ## ## The standard interpretation of the above is that, on the hypothesis
## ## ## that the fish were sampled from a population in which the mean length
## ## ## was 36 (and the distribution of length is sufficiently close to
## ## ## Normal for the t-test to be adequately applicable), then the value
## ## ## of t differs from 0 by an amount which has probability less than
## ## ## 0.05 of being attained if that hypothesis were true. Therefore the
## ## ## result is evidence of some strength that the hypotesis is not true,
## ## ## and the mean length of fish in the population is different from 36.
## ##
## ##
##
#
