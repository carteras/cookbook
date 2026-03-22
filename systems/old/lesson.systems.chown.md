# Title 

## Concept 


## Goals

## At the end of this lesson you will be able to

## Glossary

## TLDR chown

Change user and group ownership of files and directories.
More information: https://www.gnu.org/software/coreutils/chown.

 - Change the owner user of a file/directory:
   chown user path/to/file_or_directory

 - Change the owner user and group of a file/directory:
   chown user:group path/to/file_or_directory

 - Change the owner user and group to both have the name user:
   chown user: path/to/file_or_directory

 - Recursively change the owner of a directory and its contents:
   chown -R user path/to/directory

 - Change the owner of a symbolic link:
   chown -h user path/to/symlink

 - Change the owner of a file/directory to match a reference file:
   chown --reference path/to/reference_file path/to/file_or_directory

## Instructions 

```
adam@monty:~$ cd /home/notadam
-bash: cd: /home/notadam: Permission denied
```

```bash
adam@monty:~$ ls -la /home
total 20
drwxr-xr-x  5 root    root          4096 May  5 05:06 .
drwxr-xr-x 23 root    root          4096 May  5 04:39 ..
drwxr-x---  4 adam    adam          4096 May  5 04:42 adam
drwxr-x---  2 notadam notadam       4096 May  5 05:06 notadam
```

```bash
adam@monty:~$ whoami
adam
```


```bash
adam@monty:~$ sudo chown adam:notadam /home/notadam
```

```bash
adam@monty:~$ ls -la /home
total 20
drwxr-xr-x  5 root root          4096 May  5 05:06 .
drwxr-xr-x 23 root root          4096 May  5 04:39 ..
drwxr-x---  4 adam adam          4096 May  5 04:42 adam
drwxr-x---  2 adam notadam       4096 May  5 05:06 notadam
```

``bash
adam@monty:/home$ cd notadam
adam@monty:/home/notadam$ ls -la
total 20
drwxr-x--- 2 adam    notadam 4096 May  5 05:06 .
drwxr-xr-x 5 root    root    4096 May  5 05:06 ..
-rw-r--r-- 1 notadam notadam  220 Mar 31 08:41 .bash_logout
-rw-r--r-- 1 notadam notadam 3771 Mar 31 08:41 .bashrc
-rw-r--r-- 1 notadam notadam  807 Mar 31 08:41 .profile
```