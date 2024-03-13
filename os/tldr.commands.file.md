# tldr: the file command 

The file command in Linux is used to determine the type of a file based on various tests such as filesystem tests, magic number tests, and language tests. Here's a concise summary of its usage and options:

Basic usage of the file command is as follows:

```
file [options] [file...]
```

To determine the type of a single file, you would use the command like this:

```
file file1.txt
```

Some common options for the file command include:

To display output without prepending filenames, use the -b or --brief option:


```
 file -b file1.txt
```

To output MIME type strings instead of more readable descriptions, use the -i or --mime option:

```
file --mime document.pdf
```

To attempt to look inside compressed files, use the -z or --uncompress option:

```
file -z archive.tar.gz
```

To read the filenames to examine from a file, use the -f or --files-from=FILE option, replacing FILE with the name of the file containing the list of files to check:

```
file -f list_of_files.txt
```

To show the file types of all files in a directory using the file command, you can use a combination of the file command with shell wildcards or with the find command for more control, especially in directories with a large number of files or subdirectories.

```
file *
```

or 

```
file .
```

Recursively searching through directories 

```
find . -type f -exec file {} +
```

his command does the following:

find . starts the search in the current directory.
-type f specifies that you're only interested in files (not directories).
-exec file {} + executes the file command on each file found. {} is replaced by the pathname of the current file, and + at the end makes find pass all found files to file at once, reducing the number of times file is called.


