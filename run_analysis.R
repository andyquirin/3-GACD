#Part 1 - Read Tables into Memory
features      <- read.table("UCI HAR Dataset/features.txt")
trainSet      <- read.table("UCI HAR Dataset/train/X_train.txt")
testSet       <- read.table("UCI HAR Dataset/test/X_test.txt")
trainLabel    <- read.table("UCI HAR Dataset/train/y_train.txt")
testLabel     <- read.table("UCI HAR Dataset/test/y_test.txt")
label         <- read.table("UCI HAR Dataset/activity_labels.txt")
trainSubject  <- read.table("UCI HAR Dataset/train/subject_train.txt")
testSubject   <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Part 2 - Grab only the STD and Mean columns from train and test features
needed.features <- grep("std|mean", features$V2)
needed.train.features <- trainSet[,needed.features]
needed.test.features <- testSet[,needed.features]

#Part 3 - Drop Unfiltered train and test sets, and combine the two filtered datasets
rm(trainSet,testSet)
Combined.features <- rbind(needed.train.features, needed.test.features)

#Part 4 - Attach column names and remove non-combined datasets
colnames(Combined.features) <- features[needed.features, 2]
rm(needed.train.features,needed.test.features)

#Part 5 - Read and combine the train and test activity codes
Combined.activities <- rbind(trainLabel, testLabel)
Combined.activities$activity <- factor(Combined.activities$V1, levels = label$V1, labels = label$V2)

#Part 6 - Get and combine the train and test subject ids and drop pre-combined datasets
Combined.subjects <- rbind(trainSubject, testSubject)
rm(features,trainLabel,testLabel,label,trainSubject,testSubject)

#Part 7 - Combine and name subjects and activity names
Combined.data <- cbind(Combined.subjects, Combined.activities$activity)
colnames(Combined.data) <- c("SubjectID", "Activity")

#Part 8 - Generate pre-aggregated output and remove combined staging tables
PartialOutput <- cbind(Combined.data, Combined.features)
rm(Combined.activities,Combined.data,Combined.features,Combined.subjects)

#Part 9 - Aggregate output, drop partial output table from memory and write the table to text
Output <- aggregate(PartialOutput[,3:81], by = list(PartialOutput$SubjectID, PartialOutput$Activity), FUN = mean)
colnames(Output)[1:2] <- c("SubjectID", "Activity")
rm(PartialOutput)
write.table(Output, file="TidyData.txt", row.names = FALSE)

