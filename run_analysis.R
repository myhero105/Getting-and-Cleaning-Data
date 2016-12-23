#Checking for and creating directories
if(!file.exists("./data")){
        dir.create("./data")
}
#Downloading the data from zipfile
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

#Unzipping the data from zip folder to data
unzip(zipfile="./data/Dataset.zip",exdir="./data") 

#Reading training tables
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Reading test tables
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#Reading feature vector
features <- read.table('./data/UCI HAR Dataset/features.txt')

#Reading activity labels
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Merges the training and the test sets to create one data set by:
#creating x data set
x_data <- rbind(x_train, x_test)
#creating y data set
y_data <- rbind(y_train, y_test)
#creating subject data set
subject_data <- rbind(subject_train, subject_test)

#Extracts only the measurements on the mean and standard deviation for each measurement       
x_data_mean_std <- x_data[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(x_data_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 
View(x_data_mean_std)
dim(x_data_mean_std)
---------------------------------------------------------------------------------------------------------------------
#Uses descriptive activity names to name the activities in the data set
y_data[, 1] <- read.table("activity_labels.txt")[y_data[, 1], 2]
names(y_data) <- "Activity"
View(y_data)

#Appropriately labels the data set with descriptive variable names.
names(subject_data) <- "Subject"
summary(subject_data)

#Combining all data sets into one and
#Creating a second, independent tidy data set with the average of each variable for each activity and each subject
singleDataSet <- cbind(x_data_mean_std, y_data, subject_data)
View(singleDataSet)
names(singleDataSet)
average_data<-aggregate(. ~Subject + Activity, singleDataSet, mean)
average_data<-average_data[order(average_data$Subject,average_data$Activity),]
write.table(average_data, file = "tidydata.txt",row.name=FALSE)
