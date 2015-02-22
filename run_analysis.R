library(dplyr)

#
# Checks for the required "UCI HAR Dataset" folder, and 
# loads the labels for the activities and  
#       the labels for the features 
init <- function() {

  currDir <- getwd()
  #currDir <- "E:/OnlineCourses/Coursera/GettingAndCleaningData/Project"
  #setwd(currDir)
  message(paste("Current working directory is [", currDir, "]!", sep=""))
  
  dataDirBase <<- "UCI HAR Dataset"
  zipFile <<- "UCI HAR Dataset.zip"
  
  if ( !file.exists(zipFile) && !file.exists(dataDirBase)){
    stop(paste("Either the zipfile [", zipFile, "] or the extracted zip folder [", dataDirBase , "] must be present in the current working directory!", sep=""))
  } else {
    if ( file.exists(zipFile) ) {
      if ( !file.exists(dataDirBase) ) {
        message(paste("unzipping the zipFile [", zipFile, "]!" ))
        unzip(zipFile, overwrite = TRUE)
      } else {
        message(paste("Looks like the folder [", dataDirBase , "] is present!", sep=""))  
      }
    }
  }
  
  #Load the features file..
  features_file <- paste(dataDirBase, "/features.txt", sep = "")
  features <- read.table(features_file, header = FALSE, as.is=TRUE, col.names=c("Feature.Id", "Feature.Name.Full"))
  
  
  #sanitize/rename the column names!!!
  features$Feature.Name<-gsub("mean\\(\\)", "mean", features$Feature.Name.Full)
  features$Feature.Name<-gsub("std\\(\\)", "std", features$Feature.Name)
  features$Feature.Name<-gsub("BodyBody", "Body", features$Feature.Name)
  
  features$Feature.Name<-gsub("Body", ".Body", features$Feature.Name)
  features$Feature.Name<-gsub("Gravity", ".Gravity", features$Feature.Name)
  features$Feature.Name<-gsub("Acc", ".Acceleration", features$Feature.Name)
  features$Feature.Name<-gsub("Gyro", ".Orientation", features$Feature.Name)
  features$Feature.Name<-gsub("Mag", ".Magnitude", features$Feature.Name)
  features$Feature.Name<-gsub("Jerk", ".Jerk", features$Feature.Name)
  
  features$Feature.Name<-gsub("-", ".", features$Feature.Name)
  features$Feature.Name<-gsub("t\\.", "Time.", features$Feature.Name)
  features$Feature.Name<-gsub("f\\.", "Frequency.", features$Feature.Name)
  
  features <<- features
  
  #Load the activity (test lables) file..
  activity_label_file <- paste(dataDirBase, "/activity_labels.txt", sep = "")
  activities <<- read.table(activity_label_file, header = FALSE, as.is=TRUE, col.names=c("Activity.Id", "Activity.Name") )

  
}

#
# loads the data from the relevant partition(either test/train) and 
#       returns a dataframe with only the relevant columns/variables
#       along with the subject id and the activity/test id
loadData <- function(partitionName) {
  
   message(paste("loading data for ", partitionName, " partition!"))

   dirName <- paste(dataDirBase, partitionName, sep = "/")

   message("loading subject ...")
   # load subject_DDDD.txt
   fileName <- paste(dirName, "/subject_", partitionName, ".txt", sep="")
   dfSubjects<-read.table(fileName, header = FALSE, col.names="Subject.Id", comment.char="", colClasses="integer", as.is = TRUE)
   #print(head(dfSubjects))
   
   message("loading test (activities performed) ids ...")
   # load y_DDDD.txt
   fileName <- paste(dirName, "/y_", partitionName, ".txt", sep="")
   dfTests<-read.table(fileName, header = FALSE, col.names="Activity.Id", comment.char="", colClasses="integer", as.is = TRUE)
   #dfTests<-merge(activities, dfTests)
   #print(head(dfActivities))

   # merge Subjects & Activities
   dfSubjects_Tests <- cbind(dfSubjects, dfTests)

   message("loading sensor readings data ...")
   # load X_DDDD.txt
   fileName <- paste(dirName, "/X_", partitionName, ".txt", sep="")
   dfReadings<-read.table(fileName, header = FALSE, comment.char="", colClasses=c(rep("numeric",561)))
   #print(head(dfReadings))
   
   #Set the column names for X
   names(dfReadings)<-features$Feature.Name
   
   #Identify the column indices that we want
   reqd_features <<- grep("mean\\(\\)|std\\(\\)", features$Feature.Name.Full)
   
   message("merging sensor data, w Subjects/Activities and removing unwanted columns ...")
   #subset only the required features/variables!!
   dfReadings <- dfReadings[, reqd_features]

   dfReadings <- cbind(dfSubjects_Tests, dfReadings)
   #list("subject" = dfSubject, "X" = dfX, "Y" = dfY)
   
   message("done!")

   dfReadings
}

#
# main function that will be called, which does the following!
#
#   1. initializes the required master datasets, 
#   2. loads the partition (test/train) data sets
#   3. merges both the partitions
#   4. creates the averages for all the variables by Subject.Id and Activity.Id
#   5. sets the descriptive Activity Name to Activity.Id and renames the column to Activity.Name 
#   6. creates the tidy_data.txt file which contains all the averages!
#
main <- function() {

  init()
  
  dfReadingsTest <- loadData("test")
  dfReadingsTrain <- loadData("train")
  
  message("merging the test and train partition datasets!")
  dfReadingsFull <- rbind(dfReadingsTest, dfReadingsTrain)

  message("calculating the averages!")
  dfAverages <<- dfReadingsFull %>% 
    mutate(Subject.Id = as.integer(Subject.Id)) %>%
    mutate(Activity.Id = as.integer(Activity.Id)) %>%
    group_by(Subject.Id, Activity.Id ) %>% 
    summarise_each(funs(mean)) %>% 
    arrange(Subject.Id, Activity.Id) %>%
    mutate(Activity.Id =  activities[Activity.Id, ]$Activity.Name )

  colnames(dfAverages)[2]<-"Activity.Name"
  
  message("writing to the file tidy_data.txt")
  write.table(dfAverages, file="tidy_data.txt", row.names=FALSE, col.names=TRUE)
  
  message("done!")
}

main()
