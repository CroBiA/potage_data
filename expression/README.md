By default, POTAGE uses this directory for all the gene expression data to be displayed. Here, you will find information
on what data files are required and how to specify a configuration file for use by POTAGE.

# Files, Directory Structure and Formats

To help keep things organised, we advise the use of a subdirectory for each gene expression data set. If you have multiple
data sets, they will be displayed within the POTAGE interface in the order in which the directory's are listed. Therefore,
it is advisable to prefix the data set's subdirectory name with a 3-digit number. For example, the IWGSC public RNA-Seq
data set which comes with POTAGE is placed in the [expression/001_iwgsc/](expression/001_iwgsc/) subdirectory; ensuring that it will apprear first in the POTAGE interface.

The following sections describe the files required for each data set and should be placed into the data set's subdirectory.
 
## Expression Data File

TODO

## Config File
 
A plain text file, with the `.cfg` filename extension, containing tag/value pairs defining data set specific parameters.
 
### Comments
 
Lines starting with `#` are comment lines and are ignored.

### Tag Names
 
The first non-whitespace characters on non-comment files constitute the `tag name`.

Valid tags names are:

  * `ShortName` : Short name for the data set. This value is used when displaying expression information and there is limited
                  available space.
  * `LongName`  : Long name for the data set. This value is used when displaying expression information and there is more
                  space available.
  * `FileName`  : The name of the file containing expression values for the data set.
  * `Unit`      : The units of expression contained within the file defined by the `Filename` tag. Typical values for this tag are
                  `FPKM`, `CPM`, `TMM` etc ...
  
### Tag Values
 
All characters following the first group of 1 or more white-space charaters on non-comment lines constitute the `tag value`. Tag
values can contain white-space; strings should not be enclosed in quotes.

