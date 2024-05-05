# Title 

## Concept

## Goals

## At the end of this lesson you will be able to

## Glossary

* `useradd`: Adds a new user to the system.
* `useradd -m`: Adds a new user with a home directory.

## Instructions 

adam@monty:~$ sudo useradd -m notadam


Let's check that they exist now: 

adam@monty:~$ cat /etc/passwd | grep notadam
notadam:x:1002:1002::/home/notadam:/bin/sh

[username]:[password]:[userid]:[groupid]::[home path]:[bash]
