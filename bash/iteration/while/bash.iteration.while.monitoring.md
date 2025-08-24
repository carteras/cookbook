# Problem: How can you keep checking if a file exists until it appears?

*Category:* `bash.iteration.while.monitoring`

We want a loop that repeatedly tests for the presence of a file and only stops once the file is created.

## Solution

```bash
#!/bin/bash

filename="target.txt"

while [ ! -f "$filename" ]
do
  echo "Waiting for $filename to appear..."
  sleep 2
done

echo "$filename is now available!"
```

The loop runs while the condition `[ ! -f "$filename" ]` is true, meaning the file does not yet exist. On each iteration, the script prints a waiting message and pauses for 2 seconds. Once the file appears, the condition fails and the loop exits.

## Discussion

* **Why students should care about this?**
  Monitoring with a loop is a common real-world task. Scripts often need to wait for files, directories, or processes before continuing. This shows how bash can coordinate tasks that depend on external events.

* **Where else this kind of logic might be used?**
  Waiting for a log file to be created, waiting for a download to finish, waiting for a build artifact, or waiting for a service to write its output. Monitoring loops are the foundation of simple automation and orchestration.

## Challenge

Write a script that:

1. Waits for a file called `data.csv` to appear.
2. Once it exists, keeps monitoring its size until the file stops growing, then prints `"File is ready."`
