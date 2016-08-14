ReadFile <- function(filename) {
        file_conn <- file(filename, "r")
        contents <- readLines(file_conn)
        close(file_conn)
        return(contents)
}

feature_names <- ReadFile("features.txt")
activity_labels <- read.table("activity_labels.txt")

PrepareDataSet <- function(directory) {
        # Load dataset and add feature names
        dataset <- read.table(sprintf("%1$s/X_%1$s.txt", directory))
        # Label the data set with descriptive variable names
        names(dataset) <- gsub("-", ".", feature_names)
        
        # Load activity labels and merge with dataset 
        dataset_labels <- read.table(sprintf("%1$s/y_%1$s.txt", directory))
        names(dataset_labels) <- c("Activity")
        dataset <- cbind(dataset_labels, dataset)
        # Apply descriptive activity names to name the activities in the data set
        dataset$Activity <- factor(dataset$Activity, levels=activity_labels[,1], labels=activity_labels[,2])
        
        # Load subjects and merge with dataset 
        subjects <- read.table(sprintf("%1$s/subject_%1$s.txt", directory))
        names(subjects) <- c("Subject")
        dataset <- cbind(subjects, dataset)
        
        return(tbl_df(dataset))
}

# Load and prepare the training and the test sets
training_set <- PrepareDataSet("train")
testing_set <- PrepareDataSet("test")

# Merge the training and the test sets to create one data set.
combined_set <- rbind(training_set, testing_set)

# Extract only the measurements on the mean and standard deviation for each measurement.
initialTidyDataset <- combined_set[,grep("std\\(\\)|mean\\(\\)|Subject|Activity", colnames(combined_set))]
# Improve column names -- remove arbitrary numbering of columns -- remove "()" after "mean" and "std"
names(initialTidyDataset) <- lapply(names(initialTidyDataset), function(x) {sub("\\(\\)", "", if(length(strsplit(x, " ")[[1]]) > 1) strsplit(x, " ")[[1]][2] else x)})

# create a dataset with the average of each variable for each activity and each subject
finalTidyDataset <- initialTidyDataset %>% group_by(Subject, Activity) %>% summarize_each(funs(mean))

# Create file for submission
file_conn <- file("tidy_activity_data.txt", "w")
write.table(finalTidyDataset, file=file_conn, row.name=FALSE)
close(file_conn)