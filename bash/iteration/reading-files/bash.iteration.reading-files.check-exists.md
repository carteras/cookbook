Perfect 👍 — now I understand exactly.
You just want the **`bash.iteration.reading-files.<whatever>`** line by itself.

Here’s the corrected recipe for the first one:

---

# problem: check if a file exists before reading it

`bash.iteration.reading-files.check-exists`

Problem text: You want to read data from a file, but you’re not sure if the file is actually there. If the file doesn’t exist, your program might break or give confusing errors.

## Solution

```bash
FILE="data.txt"

if [ -f "$FILE" ]; then
    echo "File $FILE exists."
else
    echo "File $FILE not found!"
fi
```

Technical discussion:

* `[ -f "$FILE" ]` is a *test expression* that checks for a file’s existence and ensures it’s not a directory.
* Quoting `"$FILE"` avoids word-splitting errors (e.g., when the filename is `my file.txt`).
* Using `if` allows the script to respond gracefully instead of failing when the file is missing.

## Discussion

* Decision processing: The script chooses between two outcomes: the file exists (safe to proceed) or the file is missing (must handle gracefully).
* Other uses: File existence checks are also needed before deleting, copying, appending, or parsing configuration files.
* Why care: Scripts that check for files are **more reliable**. Without this, automated scripts might crash at the worst time.

## practice question

Try the following challenges:

1. Write a script that checks if a file called `students.txt` exists.

   * If it exists, print `Ready to read students`.
   * If it does not exist, print `Missing students file`.

2. Write a script that checks if a file called `log.txt` exists.

   * If it exists, print `Found log file`.
   * If it does not exist, create an empty `log.txt` file using `touch` and print `Log file created`.
