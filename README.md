# Introduction

This is the Project for the Coursera Course "Getting and Cleaning Data" 

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 


## Contents

The repository contains the following files as per requirements from the Project Instructions

1. README.md - this file!
2. run_analysis.R - the main .R file which cleans, processes and creates the tidy data set
3. CodeBook.md - Describes the variables, data, and transformations/work performed to clean up the data


## run_analysis.R
This .R file contains the following functions 
```
	* init()
	* load_data(partitionName)
	* main()
```
	
### init()

performs the following actions:
* Initialises the directory variables and identifies the `CURR_WORKDIR`
* Verifies whether the required folder `DATASET_FOLDER` (**UCI HAR Dataset**) or `SOURCE_ZIP` (**UCI HAR Dataset.zip**) file is present in `CURR_WORKDIR`
	- If both the `DATASET_FOLDER` and the `SOURCE_ZIP` file is **NOT** present, *stops the execution with an error message*
* If the `DATASET_FOLDER` is present, assumes that the *required files are already available* there
* If the `DATASET_FOLDER` is **NOT** present, but the `SOURCE_ZIP` is available, will extract the contents of the `SOURCE_ZIP` file
* Reads and loads the Activity Id/Labels from the file `**activity_labels.txt**` into `dfACTIVITIES` (dataframe)
* Reads and loads the Feature Labels (Sensor Data/Calculations) from the file `**features.txt**` into `dfFEATURES` (dataframe)
	- Renames/Expands/Sanitizes the Feature Labels in `dfFEATURES` dataframe 
	- format {Time|Frequency}.{Measurement|Jerk}.{mean|std}.{X|Y|Z} for all 3D measurements and the 
	- format {Time|Frequency}.{Measurement|Jerk}.{mean|std} for Magnitude calculations

### load_data(partitionName)

performs the following actions
* accepts the *partitionName* (**PPPP**) that needs to be loaded, can be either *'test'* - for testing data or *'train'* for training data
** it is expected that these folder names *test* and *train* is present under the `DATASET_FOLDER`
* Loads the data from the subject_*PPPP*.txt from the *DATASET_FOLDER\PPPP* folder and sets the column name as (Subject.Id) in `dfSUBJECTS` (dataframe)
* Loads the activity/test data from the y_*PPPP* from the *DATASET_FOLDER\PPPP* folder and sets the column name as (Activity.Id) in `dfTESTS` (dataframe)
* Merges the Subject and the Activity Performed Data into `dfSUBJECT_TEST`
* Loads the actual Sensor/Calculated Data from X_*PPPP*.txt from the *DATASET_FOLDER\PPPP* folder into `dfREADINGS` (dataframe)
..*Assigns the column names based on the `dfFEATURES` 
..*Identify the required/relevant variables for this exercise (those with mean() and std() only are selected for this exercise)
..*Subset the `dfREADINGS` to exclude unwanted variables/columns!
..*Merge the `dfREADINGS` with `dfSUBJECT_TEST`
* return the merged and properly labled `dfREADINGS` dataframe

### main()
This is the main entrypoint for this program and performs the following actions
 
* calls init() to initialize the processing environment
* calls load_data("test") to get the `dfREADINGS_TEST` and load_data("train") to get the `dfREADINGS_TRAIN`
* merges the two dataframes `dfREADINGS_TEST` and `dfREADINGS_TRAIN` to `dfREADINGS_FULL`
* creates the final dataframe `dfAVERAGES` by performing the following
..* Converts Subject.Id and Activity.Id as integers (to facilitate numerical sorting!)
..* Groups by Subject.Id and Activity.Id to capture the means of all available variables
..* Orders/arranges by Subject.Id and Activity.Id 
..* updates the Activity.Id with the actual name of the activity from `dfACTIVITIES`
..* Renames the column name Activity.Id to Activity.Name
* writes the contents of the dataframe `dfAVERAGES` to the file **tidy_data.txt**
