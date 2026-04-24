# Checking for a Missing Argument

## Problem

You want to warn the user and stop the script if they forget to pass an argument.

## Solution

Update `variables.sh` to check if `$1` is empty before continuing:

```sh
#!/bin/bash

if [[ -z $1 ]]; then
    echo "Usage: ./variables.sh <name>"
    exit 1
fi

NAME=$1

echo "Hello, $NAME!"
echo "Welcome back, $NAME."
echo "Goodbye, $NAME!"
```

## Discussion

`-z` means "is this empty?" If `$1` was not provided, the condition is true, the error message prints, and `exit 1` stops the script immediately. Nothing below it runs.

This is the simplest form of defensive scripting — check what you need early, bail out if it's not there, and let the rest of the script stay clean.