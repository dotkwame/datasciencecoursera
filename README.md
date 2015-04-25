run_analysis.R
==============

> The *run_analysis.R* file contains all the functions necessary to process and merge the data set.

### the script expects the folder *data/UCI HAR Dataset/* reads the files from.

> ## features
  Global features object that will be instanciated by merge.all.data() on first run then later utilized by process.file.data(row)

> ## merge.all.data()
  Main function to call that will load, clean build and merge the various raw raw data files.


> ## extract.and.merge.data(files)
  This function transforms the list created from the data extracted from the files into the expected dataframe. It takes as argument a list of files to extract the data from. Returns a cleaned, structured dataframe.

> ## load.file(filename)
  Work horse of the processing chain. Reads in the file from passed in as argument, then calles *process.file.data(row)* to clean each row of data.Returns a cleaned out copy of the file's data.


> ## process.file.data(row)
  Data from x_train.txt and x_test.txt contain multiple feature readings per line and are read in as character. *process.file.data(row)* tokenizes each recieved row into the various features measured and converts the result to numeric. The relevant *features* are selected using their positions.

> ## rename.activity.factors(all.data)
  Replaces the numeric factor labels to readable labels.

> ## retrieve.features()
  Prepares and selects the feature labels of interest from the main list. Their positions are also noted to be used by *process.file.data(row)

> ## avg.vars.subject.activity(data = merge.all.data())
  Accepts as input a dataframe to, which gets converted to a datable to work with. Where no arguments is passed in *merge.all.data()* is called which returns the complete data set. Returns a tidy data set with the average of each variable for each activity and each subject
