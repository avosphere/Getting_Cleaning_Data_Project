# Getting and Cleaning Data Course Project

  # This is an R script called run_analysis.R that: 
  #1) Merges the training and the test sets to create one data set.
  #2) Extracts only the measurements on the mean and standard deviation for each measurement. 
  #3) Uses descriptive activity names to name the activities in the data set
  #4) Appropriately labels the data set with descriptive variable names. 
  #5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# set a working directory
mypath = "/Users/avultur/Desktop/RStudio/R_ThirdCourse/Week4/GetCleanDataProject4"
setwd(mypath)

#load relevant package
install.packages("dplyr")
library(dplyr)

# assign the zip file url to a new variable, download the file, and unzip it
accelerometer_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(accelerometer_url, "accelerometerGalS.zip")
unzip("accelerometerGalS.zip", list = TRUE)  

#Part 1: Merge the training and the test sets to create one data set.

# load the feature names as characters to assign them as column names to data
features <- read.table("./UCI HAR Dataset/features.txt", sep=" ")
features_list <- as.character(features[,2])

# load the test data and training data, assigning them each the column names from "features_list"
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features_list)
training_data <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features_list)

# add activity code to the test data
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
Ytest<- cbind(y_test, test_data)

# add activity code to the train data
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
Ytrain <- cbind(y_train, training_data)

# add subject code to the Ytest data
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
col_rows_test <- cbind(subject_test, Ytest)

# add subject code to the Ytrain data
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
col_rows_train <- cbind(subject_train, Ytrain)

# merge or combine the test and train data (row-based)
test_train_combo <- rbind(col_rows_test, col_rows_train)

# re-label the first two columns
colnames(test_train_combo)[1] <- "Subject_Code"
colnames(test_train_combo)[2] <- "Activity_Code"

# Part 2: Extract only the measurements on the mean and standard deviation for each measurement.
  mean_std <- test_train_combo[ , grep("Subject|Activity|mean|std", names(test_train_combo))]

# Part 3: Use descriptive activity names to name the activities in the data set
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity)[1] <- "Activity_Code"
colnames(activity)[2] <- "Activity"

#merge the mean_std file with the activity code file
act_mean_std <- merge(activity, mean_std, by.x = "Activity_Code", by.y = "Activity_Code")
  
# Part 4: label data set with descriptive variable name
# Already done above

# Part 5: From data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy <- group_by(act_mean_std, Subject_Code, Activity)
outtidy <- summarize_each(tidy, list(mean))

# Create output tidy .txt file
write.table(outtidy, file="./AVtidy.txt", row.names=FALSE)
