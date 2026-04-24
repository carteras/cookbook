# Using Command Line Arguments

## Problem

Your variable is hardcoded in the script. Every time you want a different value you have to edit the file.

## Solution

Update `variables.sh` to accept a value from the command line:

```sh
#!/bin/bash
NAME=$1

echo "Hello, $NAME!"
echo "Welcome back, $NAME."
echo "Goodbye, $NAME!"
```

Now pass the value when you run it:

```
./variables.sh Alice
```

## Discussion

`$1` is a special variable that holds the first argument you pass to the script. Instead of the value living inside the file, it comes in from outside at runtime. The script stays the same — only the input changes.

This is the difference between a script that does one specific thing and a script that does something useful for anyone who runs it.