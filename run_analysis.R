
################################################
#
# Data cleaning Script
# Noel Figuera
#

######### Test data
#########
library(plyr)
library(reshape2)

# retrieve features names
file <- "./data/mobile/features.txt"
labels <- read.table(file, sep="")
names(labels) <- c("pos", "metric")

#retrieve activity labels
file <- "./data/mobile/activity_labels.txt"
activity <- read.table(file, sep="")
names(activity) <- c("actionid", "action")

# upload test x data
file <- "./data/mobile/test/X_test.txt"
xtest <- read.table(file, sep="")
names(xtest) <- labels$metric

# upload test labels data
file <- "./data/mobile/test/y_test.txt"
ytest <- read.table(file, sep="")
names(ytest) <- "actionid"

# upload subject data
file <- "./data/mobile/test/subject_test.txt"
testSubject <- read.table(file, sep="")
names(testSubject) <- "subject"

# merge the action id with the name
ytest <- merge(ytest, activity, by="actionid" )

# consolidate the test samples
testData <- cbind(ytest,testSubject, xtest)

######### Train data
#########

# upload train x data
file <- "./data/mobile/train/X_train.txt"
xtrain <- read.table(file, sep="")
names(xtrain) <- labels$metric

# upload train labels data
file <- "./data/mobile/train/y_train.txt"
ytrain <- read.table(file, sep="")
names(ytrain) <- "actionid"

# upload subject data
file <- "./data/mobile/train/subject_train.txt"
trainSubject <- read.table(file, sep="")
names(trainSubject) <- "subject"

# STEP  3

# merge the action id with the name
ytrain <- merge(ytrain, activity, by="actionid" )

# consolidate the test samples
trainData <- cbind(ytrain, trainSubject, xtrain)

# STEP  1

# consolidate sample of both datasets
allData <-rbind(trainData, testData)

# STEP  3
names(allData) <- tolower(names(allData))

# extract only the mean and standard deviation
vt <- grep("mean\\(\\)|std\\(\\)",names(allData))

# STEP 2

# subset the data using the previously built grep command
subsetData <- as.data.frame(allData)[,c(1:3,vt)]

# STEP 5
#create a new clean dataset, using package reshape2
#creates a variable column and adds one row per variable observation
dMelt <- melt(subsetData, id =c("actionid", "action", "subject"), measure.vars=c(4:69))

subjectData <- dcast(dMelt, subject ~ variable, mean)