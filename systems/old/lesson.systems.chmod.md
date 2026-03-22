# Title 

## Concept 


## Goals

## At the end of this lesson you will be able to

## Glossary

## TLDR chmod

Change the access permissions of a file or directory.
More information: https://www.gnu.org/software/coreutils/chmod.

 - Give the [u]ser who owns a file the right to e[x]ecute it:
   chmod u+x path/to/file

 - Give the [u]ser rights to [r]ead and [w]rite to a file/directory:
   chmod u+rw path/to/file_or_directory

 - Remove e[x]ecutable rights from the [g]roup:
   chmod g-x path/to/file

 - Give [a]ll users rights to [r]ead and e[x]ecute:
   chmod a+rx path/to/file

 - Give [o]thers (not in the file owner's group) the same rights as the [g]roup:
   chmod o=g path/to/file

 - Remove all rights from [o]thers:
   chmod o= path/to/file

 - Change permissions recursively giving [g]roup and [o]thers the ability to [w]rite:
   chmod -R g+w,o+w path/to/directory

 - Recursively give [a]ll users [r]ead permissions to files and e[X]ecute permissions to sub-directories within a directory:   
   chmod -R a+rX path/to/directory

## Instructions 

```bash
adam@monty:/home/notadam$ ls -la
total 20
drwxr-x--- 2 adam    notadam 4096 May  5 05:06 .
drwxr-xr-x 5 root    root    4096 May  5 05:06 ..
-rw-r--r-- 1 notadam notadam  220 Mar 31 08:41 .bash_logout
-rw-r--r-- 1 notadam notadam 3771 Mar 31 08:41 .bashrc
-rw-r--r-- 1 notadam notadam  807 Mar 31 08:41 .profile
```

```bash
adam@monty:/home/notadam$ sudo chmod u+rw,g+r .*
adam@monty:/home/notadam$ ls -la
total 20
drwxr-x--- 2 adam    notadam 4096 May  5 05:06 .
drwxr-xr-x 5 root    root    4096 May  5 05:06 ..
-rw-r--r-- 1 notadam notadam  220 Mar 31 08:41 .bash_logout
-rw-r--r-- 1 notadam notadam 3771 Mar 31 08:41 .bashrc
-rw-r--r-- 1 notadam notadam  807 Mar 31 08:41 .profile
```

```bash
adam@monty:/home/notadam$ sudo chmod o-r .*
adam@monty:/home/notadam$ ls -la
total 20
drwxr-x--- 2 adam    notadam 4096 May  5 05:06 .
drwxr-xr-x 5 root    root    4096 May  5 05:06 ..
-rw-r----- 1 notadam notadam  220 Mar 31 08:41 .bash_logout
-rw-r----- 1 notadam notadam 3771 Mar 31 08:41 .bashrc
-rw-r----- 1 notadam notadam  807 Mar 31 08:41 .profile
```
