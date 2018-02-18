library(dplyr)

#downloaded the file form the link and load all the data (address to my directory incomplete)
x_test <- read.table("./coursera/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./coursera/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./coursera/UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("./coursera/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./coursera/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./coursera/UCI HAR Dataset/train/subject_train.txt")

#read activity labels and features
activity_labels <- read.table("./coursera/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./coursera/UCI HAR Dataset/features.txt")

#merge train and test data
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subjects <- rbind(subject_train, subject_test)

#get features that are mean or std deviation
#there are frequency mean variables but i assumed we don't need those ones, otherwise regexp would be different
#could also change column names to a nicer format, but the user might be familiar with this one
features_relevant <- features[grep("mean\\(\\)|std\\(\\)", features[,2]),]

#keep only relevant features
x_relevant <- x[,features_relevant[,1]]

#assign labels to columns
colnames(x_relevant) <-  features[features_relevant[,1],2]
colnames(y) <- "activity"
y$activity_name <- factor(y$activity, labels = as.character(activity_labels[,2]))
activity_name = y[,-1]
colnames(subjects) <- "subject"

#merge all to obtain full data set

full_dataset <- cbind(activity_name, subjects, x_relevant)

#create aggregated table for each activity and subject
subject_activity_agg <- full_dataset %>% group_by(activity_name, subject) %>% summarize_all(funs(mean))
write.table(subject_activity_agg, "tidy.txt", row.names=FALSE)