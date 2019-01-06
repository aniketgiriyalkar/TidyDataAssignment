# DOWNLOADING DATA
# setting working directory
workDir <- setwd("set your working directory here")

# saving url adress to the data file
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# downliading the data into working directory
download.file(dataUrl, "Dataset.zip")

# unziping the data into working directory
unzip("Dataset.zip")



# GETTING, CLEANING AND MERGING TEST DATA
# getting data about TEST subjects and naming the column
TstSdata <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                     col.names = "Subject")
str(TstSdata)



# getting activity labels for TEST data and naming the column
TstAdata <- read.table("./UCI HAR Dataset/test/y_test.txt",
                     col.names = "Activity")
str(TstAdata)



# getting variable names for measure data as a character vector
VarNames <- as.character(read.table("./UCI HAR Dataset/features.txt",
                                    colClasses = c("NULL", NA))$V2)
head(VarNames)
str(VarNames)



# getting measure data for TEST subjects and naming all columns
# (using the vector)
# all "-", "," and "()" are going to change into "." - we will take care of it later
TstMdata <- read.table("./UCI HAR Dataset/test/X_test.txt",
                     col.names = VarNames)
str(TstMdata)

# creating logical vector for "mean" or "std" columns names
SelVarNames <- grepl("mean|std", names(TstMdata))
SelVarNames
table(SelVarNames)

# keeping only columns with "mean" or "std" in measure data for TEST subjects
# (using the vector)
TstMdata <- TstMdata[, SelVarNames]
str(TstMdata)



# column binding all three TEST data frames
TestData <- cbind(TstSdata, TstAdata, TstMdata)
str(TestData)
names(TestData)



# GETTING, CLEANING AND MERGING TRAIN DATA
# getting data about TRAIN subjects and naming the column
TrnSdata <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                     col.names = "Subject")
str(TrnSdata)

# getting activity labels for TRAIN data and naming the column
TrnAdata <- read.table("./UCI HAR Dataset/train/y_train.txt",
                     col.names = "Activity")
str(TrnAdata)

# getting measure data for TRAIN subjects and naming all columns
# (using the vector) - we have it from previous procedures for TEST data
# all "-", "," and "()" are going to change into "." - we will take care of it later
TrnMdata <- read.table("./UCI HAR Dataset/train/X_train.txt",
                       col.names = VarNames)
str(TrnMdata)

# keeping only columns with "mean" or "std" in measure data for TRAIN subjects
# (using the vector) - we have it from previous procedures for TEST data
TrnMdata <- TrnMdata[, SelVarNames]
str(TrnMdata)

# column binding all three TEST data frames
TrainData <- cbind(TrnSdata, TrnAdata, TrnMdata)
str(TrainData)
names(TrainData)



# FINAL BINDING AND CLEANING
# row binding TEST and TRAIN data frames
AllData <- rbind(TestData, TrainData)
str(AllData)
names(AllData)
# removing ".." from variable names
colnames(AllData) <- gsub("\\.\\.", "", names(AllData))
names(AllData)
# getting descriptive activity names/value labels ...
ActNames <- as.character(read.table("./UCI HAR Dataset/activity_labels.txt",
                                    colClasses = c("NULL", NA))$V2)
head(ActNames)
# ... and applying them to the activities codes in the data set
table(AllData$Activity)
AllData$Activity <- factor(AllData$Activity,
                           levels = c(1, 2, 3, 4, 5, 6),
                           labels = ActNames) 
table(AllData$Activity)



# CREATING A SECOND, INDEPENDENT TIDY DATA SET
# WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT
AllDataTidy <- aggregate(. ~ Activity + Subject,
                         data = AllData,
                         mean)
head(AllDataTidy, 10)

# writing it down into working directory
write.table(AllDataTidy, "AllDataTidy.txt")

# and reading it again
AllDataTidy <- read.table("AllDataTidy.txt")
head(AllDataTidy, 10)
