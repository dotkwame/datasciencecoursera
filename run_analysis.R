
if(!require(data.table)){
    stop("please install the data.table package before running this script")    
}


path.to.data <- "./data/"

if(!exists("features")){
        features <<- NULL
}

merge.all.data <- function(){
        subject.train = paste(path.to.data, "UCI HAR Dataset/train/subject_train.txt", sep = "")
        x.train = paste(path.to.data, "UCI HAR Dataset/train/X_train.txt", sep = "")
        y.train = paste(path.to.data,"UCI HAR Dataset/train/y_train.txt", sep = "")
        
        subject.test = paste(path.to.data, "UCI HAR Dataset/test/subject_test.txt", sep = "")
        x.test = paste(path.to.data, "UCI HAR Dataset/test/X_test.txt", sep = "")
        y.test = paste(path.to.data, "UCI HAR Dataset/test/y_test.txt", sep = "")
        
        if (is.null(features))
                features <<- retrieve.features()        
        
        train.data.files <- c(subject = subject.train, x = x.train, activity = y.train)
        test.data.files <- c(subject = subject.test, x = x.test, activity = y.test)
        
        train.data <- extract.and.merge.data(train.data.files)
        #browser()
        test.data <- extract.and.merge.data(test.data.files)
        
        merged.data <- rbind(train.data, test.data)
        
        merged.data$subject <- as.factor(merged.data$subject)
        
        merged.data$activity <- as.factor(merged.data$activity)
        
        merged.data <- rename.activity.factors(merged.data)
        
        merged.data        
}

# Build and merge the pieces of data that has been generated
extract.and.merge.data <- function(files){
        file.data <- lapply(files, load.file)
        
        t.data <- data.frame(subject = numeric(), activity = numeric())
        #t.data <- data.table(subject = numeric(), activity = numeric())
        fs <- features$feature;
        num.fs <- length(fs)
        
        for(i in 1:num.fs){
                n = fs[i]
                
                t.data[n] <- numeric()
        
                #t.data[,eval(quote(n)) := numeric()] #<- numeric()                
        }
        
        l <- length(file.data$subject)
        
        for(i in 1:l){
                s = unlist(file.data$subject[i])
                a = unlist(file.data$activity[i])
                x = unlist(file.data$x[i])
                
                r = c(s, a, x)
                
                t.data[nrow(t.data)+1, ] <- r                
        }
        
        t.data
}

# Load file from the supplied filename
# Use fread for speedy file reading
load.file <- function(filename){        
        raw.data <- fread(filename, header=F, sep="\n")
        #raw.data <- as.data.frame(raw.data)
        
        #clean.data <- lapply(raw.data[,1], process.file.data)
        
        clean.data <- lapply(unlist(raw.data[,1, with = FALSE]), process.file.data)
        
        #browser()
        
        clean.data
}

# Initial cleaning of raw data retrieved from the file passed in as argument row
# row will either contain a unit character value (if data is from files named y_* or subject_*)
# or a character vector which contains each measured variable separated by space
process.file.data <- function(row){    
        
        if(is.character(row))        
                row <- unlist(strsplit(row, " "))                
        
        vals <- row[row != ""]
        
        vals <- as.numeric(vals)
        # If length < 1 then we have list of 
        if(length(vals) > 1){
                vals <- vals[features$pos]  
                vals <- as.list(vals)                
        }
        
        vals        
}

# Convert activity labels from integers to their actual name equivalents
rename.activity.factors <- function(data){
        activity.labels <- read.table("data/UCI HAR Dataset/activity_labels.txt", sep = " ")
        
        activity.labels[,1] <- as.factor(activity.labels[,1])
        activity.labels[,2] <- as.factor(activity.labels[,2])
        
        data$activity <- as.factor(data$activity)
        
        levels(data$activity) <- levels(activity.labels[,2])
        
        data
}

# Build a dataframe of variables names we want to retrive 
# from the main list found in features.txt
retrieve.features <- function(){
        drxns <- c("X", "Y", "Z")        
        avgs <- c("mean()", "std()")
        signals <- c("tBodyAcc",
                     "tGravityAcc",
                     "tBodyAccJerk",
                     "tBodyGyro",
                     "tBodyGyroJerk",
                     "tBodyAccMag",
                     "tGravityAccMag",
                     "tBodyAccJerkMag",
                     "tBodyGyroMag",
                     "tBodyGyroJerkMag",
                     "fBodyAcc",
                     "fBodyAccJerk",
                     "fBodyGyro",
                     "fBodyAccMag",
                     "fBodyAccJerkMag",
                     "fBodyGyroMag",
                     "fBodyGyroJerkMag")
        
        # features without directional component.
        drxns1 <- rep(drxns, 2 * 17)
        avgs1 <- rep(avgs, 3 * 17) 
        signals1 <- rep(signals, 2 * 3) 
        
        feature.ids<- sprintf("%s-%s-%s", signals1, avgs1, drxns1)
        
        # features with direction component.
        avgs2 <- rep(avgs, 17)
        signals2 <- rep(signals, 2)
        
        feature.ids2<- sprintf("%s-%s", signals2, avgs2)
        
        features.label <- read.table("data/UCI HAR Dataset/features.txt", sep = " ")
        
        selected.features <- features.label[features.label[,2] %in%  feature.ids,]
        selected.features2 <- features.label[features.label[,2] %in%  feature.ids2,]
        
        s.features <- rbind(selected.features, selected.features2)
        names(s.features) <- c("pos", "feature")
        
        s.features$feature <- as.character(s.features$feature)
        s.features$feature <- sub("-", "_", s.features$feature)        
        s.features$feature <- gsub("\\()", "", s.features$feature)        
        s.features$feature <- gsub("-", "", s.features$feature)
        s.features$feature <- gsub(" ", "", s.features$feature)
        s.features
}

# Process the average of each variable for each activity by each subject
# Pass in argument of data frame or will retrive one by calling merge.data()
avg.vars.subject.activity <- function(data = merge.all.data()){
        data <- data.table(data)
        means.vars <- data[, lapply(.SD, mean), by = .(subject, activity), .SDcols=c(features$feature)]
        means.vars <- means.vars[order(subject, activity)]
        means.vars       
}

tidy.dataset <- avg.vars.subject.activity()
write.table(avg, file = "tidydataset.txt", row.name=FALSE)

