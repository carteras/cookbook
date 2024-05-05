# Title 

## Concept 

## Goals

## At the end of this lesson you will be able to

## Glossary

## TLDR touch

Create files and set access/modification times.
More information: https://manned.org/man/freebsd-13.1/touch.

- Create specific files:
touch path/to/file1 path/to/file2 ...

- Set the file [a]ccess or [m]odification times to the current one and don't [c]reate file if it doesn't exist:
touch -c -a|m path/to/file1 path/to/file2 ...

- Set the file [t]ime to a specific value and don't [c]reate file if it doesn't exist:
touch -c -t YYYYMMDDHHMM.SS path/to/file1 path/to/file2 ...

- Set the file time of a specific file to the time of anothe[r] file and don't [c]reate file if it doesn't exist:
touch -c -r ~/.emacs path/to/file1 path/to/file2 ...

## Instructions

```bash
adam@monty:/home/notadam$ touch secret.flag
adam@monty:/home/notadam$ ls -la
total 20
drwxr-x--- 2 adam    notadam 4096 May  5 05:21 .
drwxr-xr-x 5 root    root    4096 May  5 05:06 ..
-rw-r----- 1 notadam notadam  220 Mar 31 08:41 .bash_logout
-rw-r----- 1 notadam notadam 3771 Mar 31 08:41 .bashrc
-rw-r----- 1 notadam notadam  807 Mar 31 08:41 .profile
-rw-rw-r-- 1 adam    adam       0 May  5 05:21 secret.flag
```

```bash
adam@monty:/home/notadam$ sudo chown adam:notadam secret.flag
adam@monty:/home/notadam$ ls -la | grep flag
-rw-rw-r-- 1 adam    notadam    0 May  5 05:21 secret.flag
```

```bash
adam@monty:/home/notadam$ sudo chmod g-w,o-r secret.flag
adam@monty:/home/notadam$ ls -la | grep flag
-rw-r----- 1 adam    notadam    0 May  5 05:21 secret.flag
```
