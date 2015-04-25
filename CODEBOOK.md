> ##Setup:
The dataset is version 1.0 of Human Activity Recognition Using Smartphones experiments by the Center for Machine Learning and Intelligent Systems at the University of California, Irvine. Retrieved from [here.](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The experiments involved a group of 30 volunteers performing six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz was captured.


> ##Raw data:
The following details the files and data of interest.

- *features_info.txt:* Shows information about the variables used on the feature vector.

- *features.txt:* List of all 561 features. Each feature in the list has a corresponding value in each row of values in the *X_train.txt* and *X_test.txt* file. Only features with measurements on the mean and standard deviation for each measurement was selected making a total of 60 feature out of the lot.

- *activity_labels.txt:* Links the class labels with their activity name.

- *train/X_train.txt:* Training set. Each row in the file contains all 561 data feature measurements. [Same for test/X_test.txt]

- *train/y_test.txt:* Numeric training labels for activity, each row matches each feature set row in the *features.txt*. The activity names can be found in *activity_labels*. [Same for test/y_train.txt]

- *train/subject_train.txt*: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. [Same for file in test/subject_test.txt]

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

> ##Processed Data:

* Feature selection:
  The *means* and *standard deviation* following features of the following features were selected along with their position numbers into a dataframe from the *features.txt*. Features marked *-XYZ* indicate the feature had individual *-X*, *-Y*, and *-Z* each with their own means and standard deviation.
  * tBodyAcc-XYZ
  * tGravityAcc-XYZ
  * tBodyAccJerk-XYZ
  * tBodyGyro-XYZ
  * tBodyGyroJerk-XYZ
  * tBodyAccMag
  * tGravityAccMag
  * tBodyAccJerkMag
  * tBodyGyroMag
  * tBodyGyroJerkMag
  * fBodyAcc-XYZ
  * fBodyAccJerk-XYZ
  * fBodyGyro-XYZ
  * fBodyAccMag
  * fBodyAccJerkMag
  * fBodyGyroMag
  * fBodyGyroJerkMag

  Features names with -XYZ were transformed into number with variable name in the form feature_meanX or feature_std eg tBodyAcc_meanX, fBodyAccJerk_meanY, tBodyGyroMag_mean etc.
    > ## Note the following to interpret each feature:
    1. *t- features* with this prefix are time domain signals recorded for each axis from
    2. *f- features* with this prefix are frequency domain computed by applying Fast Fourier Transform (FFT) on some signals.
    3. *-Mag features* with this suffix are the magnitude of its three-dimensional signals calculated using the Euclidean norm
    4. *-Acc-* measures from the accelerometer
    5. *-Gyro-* measures from the gyroscope
    6. *-BodyAcc-* actual body acceleration measure of the signal
    7. *-GravityAcc-* gravitational acceleration of the signal
    8. *-BodyAccJerk-* body linear acceleration derived in time
    9. *-GyroAccJerk-* angular velocity derived in time
    10. *-XYZ* any of the 3-axial dimensions of a feature

* Subject from the subject_test and subject_train files were transformed into factors.

* Activity IDs were transformed to factors and changed to their actual names.

* Each line in the subject_[train|test].txt was merged with the corresponding line in y_[train|test].txt (representing the activity).

* Features were first trimmed down as indicated in the earlier section, each feature being a column. Then the result was merged with the above to create a table with subject, activity, features (60 of them) as column. Each row then becomes a subject, the activity they performed and the list of relevant features of interest.




