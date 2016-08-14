# Running The Script

This script assumes you have downloaded the file "UCI HAR Dataset.zip", available [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), and are in the top level directory where the files are extracted.

For example, to change to the appropriate directory in R, you can run the `setwd` command
```setwd("/Users/gpeek/Documents/education/data\_science\_track\_johns\_hopkins/getting\_and\_cleaning_data/UCI HAR Dataset")```

The resulting file can be read and displayed with the following commands

```data <- read.table("tidy\_activity\_data.txt", header = TRUE)
View(data)```

# Processing Performed
The script combines the training and testing datasets, after inserting column headers and adding columns for activity and subject in a uniform way to each dataset.
Once combined, the relevant columns are selected. From there, the dataset is grouped by subject and activity and the observations in each grouping are averaged. 
Finally, the script produces a text file of a tidy dataset which conforms to the principles set forth by Hadley Wickham (Wickham 2014):
> 1.  Each variable forms a column.
> 2.  Each observation forms a row.
> 3.  Each type of observational unit forms a table.

# The Data
Details of the variables, data and transformations used are available in the file `CodeBook.md`
Not knowing what problems future consumers of this data would be attempting to solve, I chose to leave the data in a "wide" format. If needed, consumers of this tidy dataset will easily be able to melt the columns, etc., if necessary. 

# References
(Wickham, Hadley. "Tidy Data." Journal of Statistical Software J. Stat. Soft. 59.10 (2014): n. pag. Web.)