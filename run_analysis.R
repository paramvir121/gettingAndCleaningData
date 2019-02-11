#Here are the data for the project:
  
 # https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.
#Good luck!

setwd("D:/E drive data/R working/Data Science Assignment/getting and cleaning data/")
downloadExerciseData = function() {
  if (!file.exists("UCI HAR Dataset")) {
    # download the data
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipfile="UCI_HAR_data.zip"
    message("Downloading data")
    download.file(fileURL, destfile=zipfile, method="curl")
    unzip(zipfile, exdir="getting and cleaning data")
  }
}
downloadExerciseData


getwd()
# Step1. Merges the training and the test sets to create one data set.
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")
dim(trainData) # 7352*561
class(trainData)
trainLabel <- read.table("./UCI HAR Dataset/train/y_train.txt")
class(trainLabel)
#table(trainLabel)
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
dim(trainSubject)
trainSubject
testData <- read.table("./UCI HAR Dataset/test/X_test.txt")
dim(testData) # 2947*561
testLabel <- read.table("./UCI HAR Dataset/test/y_test.txt") 
#table(testLabel) 
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
joinData <- rbind(trainData, testData)
dim(joinData) # 10299*561
joinLabel <- rbind(trainLabel, testLabel)
dim(joinLabel) # 10299*1
joinSubject <- rbind(trainSubject, testSubject)
dim(joinSubject) # 10299*1


# Step2. Extracts only the measurements on the mean and standard 
# deviation for each measurement. 
features <- read.table("./UCI HAR Dataset/features.txt")
dim(features)  # 561*2
View(features)
?grep
meanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
meanStdIndices
length(meanStdIndices) # 66
subsetJoinData <- joinData[, meanStdIndices]
View(joinData)
View(meanStdIndices)
dim(subsetJoinData) # 10299*66
names(subsetJoinData) <- features[meanStdIndices, 2]

# Step3. Uses descriptive activity names to name the activities in 
# the data set
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
View(activity)
View(joinSubject)
names(joinSubject) <- "Subject"

activityLabel <- activity[joinLabel[, 1], 2]
joinLabel[, 1] <- activityLabel
names(joinLabel) <- "Activity"

# Step4. Appropriately labels the data set with descriptive activity names. 
names(joinSubject) <- "Subject"
overallData <- cbind(joinSubject, joinLabel, subsetJoinData)
dim(overallData) # 10299*68
View(overallData) 
write.table(overallData, "overall_data.txt") 


# Step5. Creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject. 
install.packages('dplyr')
library(dplyr)
summView <- overallData %>% group_by(overallData[,1], overallData[,2] ) %>% summarise_at(c(3:68), funs(mean))
View(summView)
write.table(summView, "Final_data_with_means.txt") 