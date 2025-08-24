# Problem: How can you wait in a loop until a folder called `backup/` is created?

*Category:* `bash.iteration.while.waiting`

We want a script that checks whether a directory exists, and only continues once the directory `backup/` is available.

## Solution

```bash
#!/bin/bash

dir="backup"

while [ ! -d "$dir" ]
do
  echo "Waiting for directory $dir/ to be created..."
  sleep 2
done

echo "Directory $dir/ is now available!"
```

The loop runs while `[ ! -d "$dir" ]` is true, meaning the directory does not exist. Each cycle prints a message and pauses for 2 seconds. Once the directory is created, the condition fails, and the loop exits.

## Discussion

* **Why students should care about this?**
  This pattern shows how bash can synchronize scripts with filesystem events. Many tasks depend on a directory being available before proceeding, especially in automated environments.

* **Where else this kind of logic might be used?**
  Waiting for a mounted volume, a build output folder, or a backup target. It’s also common in deployment scripts that depend on external services writing data to specific locations.

## Challenge

Write a script that:

1. Waits until a directory called `logs/` exists.
2. Once it exists, keeps waiting until a file called `error.log` appears inside it.
3. After both conditions are met, print `"Logs are ready."`
