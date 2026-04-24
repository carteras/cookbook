# First Shell Script

## Problem

You need to run the same command repeatedly without mistyping it every time, and you want to be able to update it in one place as your needs change.

## Solution

Save your command in a file called `simple.sh` and run it with `bash`:

```sh
echo "Hello, World!"
```

Run it like this:

```
bash simple.sh
```

## Discussion

Typing commands directly into the terminal works fine once or twice. But the moment you find yourself running the same command over and over, you're setting yourself up for trouble. One misplaced character and the command fails, or worse, does something you didn't intend.

A shell script is just a plain text file containing the commands you would have typed by hand. When you run `bash simple.sh`, Bash reads the file and executes each line exactly as written, every single time.

