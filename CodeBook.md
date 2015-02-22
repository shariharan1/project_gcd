# Introduction

This is the CodeBook for the Coursera Course "Getting and Cleaning Data"! on `Human Activity Recognition Using Smartphones Data Set` 

## Source Data

###Data Set Information

The raw data has been collected based on experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity data were captured at a constant rate of 50Hz. The obtained dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

For more information on the Source Data Set, please visit UCI Machine Learning Repository, [Centre for Machine Learning and Intelligent Systems](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)

###Details on the source data
- Source data has 561 variables measured/calculated against the 30 subjects
- Test partition has around 2947 observations with 561 variables
- Train partition has around 7352 observations with 561 variables
- Both Test and Train partition data has the relevant Subject Id and the Test Performed in seperate files

###Authors
Here are the authors
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

## Objective

### Target Tidy Data Set

As per the requirements for this project we were required to do the following:
```
1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the **mean** and **standard deviation** for each measurement. 
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```

### Variables

Following are the variables captured in the final tidy data set

`Subject.Id`: Identifies the subject(participant) who performed the activity for each window sample. Its range is from 1 to 30. 

`Activity.Name`: Identifies the activitiy performed by the subject and following are the activities performed (WALKING,WALKING_UPSTAIRS,WALKING_DOWNSTAIRS,SITTING,STANDING,LAYING) 

Measurements: For each `Subject.Id` and `Activity.Name` the average(mean) of each of measurements are captured as shown below. While from the source data, the mean/standard deviation were retreived, the final data set only stored the average of these values.
| Variable/Column Name|Description|
|---------------------|-----------|
|{Time\|Frequency}.Body.Acceleration.{mean\|std}.{X\|Y\|Z} | Average of the 3 axis signals for Body Acceleration on both Time & Frequency Domains
|{Time\|Frequency}.Body.Acceleration.Jerk.{mean\|std}.{X\|Y\|Z} | Average of the 3 axis signals for Linear Acceleration on both Time & Frequency Domains
|{Time\|Frequency}.Body.Orientation.{mean\|std}.{X\|Y\|Z} | Average of the 3 axis signals for Angular Velocity on both Time & Frequency Domains
|{Time\|Frequency}.Body.Acceleration.Magnitude.{mean\|std} | Average of the Magnitude of the Body Acceleration
|{Time\|Frequency}.Body.Acceleration.Jerk.Magnitude.{mean\|std} | Average of the Magnitude of the Linear Acceleration 
|{Time\|Frequency}.Body.Orientation.Magnitude.{mean\|std} | Average of the Magnitude of the Angular Velocity 
|{Time\|Frequency}.Body.Orientation.Jerk.Magnitude.{mean\|std} | Average of the Magnitude of the Angular Velocity Jerk
|{Time}.Body.Orientation.Jerk.{mean\|std}.{X\|Y\|Z} | Average of the 3 axis signals for Angular Velocity on Time Domain
|{Time}.Gravity.Acceleration.{mean\|std}.{X\|Y\|Z} | Average of the 3 axis signals for Gravity Acceleration on Time Domain 
|{Time}.Gravity.Acceleration.Magnitude.{mean\|std} | Average of the Gravity Acceleration Magnitude

### Transformations/Processes Performed

```
Tidy Data Principles Applied
```

1. the seperate datasets for `train` and `test` partitions were merged together to form a single dataset
2. seperate files identifying the subjects, activities and measurement data were merged together to properly identify each observation and the variables
3. Each variable was given a proper human readable name


```
Others
```

4. Only the variables with the names `mean()` and `std()` from the source data set was selected as per the assignment requirements
5. Though only the mean and std values were selected from the source, the final data set actually consists of the average of mean and std for each of the measurements
