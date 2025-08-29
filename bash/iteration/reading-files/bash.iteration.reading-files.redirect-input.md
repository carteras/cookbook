# problem: redirect a file into a loop for line-by-line processing

`bash.iteration.reading-files.redirect-input`

Problem text: You want your loop to read from a file automatically, without typing file-reading commands on every iteration.

## Solution

```bash
FILE="students.txt"

while IFS= read -r line; do
    echo "Student: $line"
done < "$FILE"
```

Technical discussion:

* `< "$FILE"` **redirects the file** to the loop’s standard input; `read` pulls one line per iteration.
* This pattern avoids using `cat` in a subshell and keeps the loop control simple.
* Quoting `"$FILE"` protects filenames with spaces.
* Alternative: `while ...; do ...; done <<< "$text"` feeds a single string instead of a file.

## Discussion

* Decision processing: Prefer redirection on the loop (`... done < file`) for clarity and correctness.
* Where else used: Processing logs, CSVs, or any line-based data.
* Why care: This is the standard, readable way to connect a file to your loop.

## practice question

1. Create `todo.txt` with a few tasks (one per line). Write a script using `while IFS= read -r line; do ... done < "$FILE"` to print `TODO: <task>`.
2. Create `colors.txt` and print each color in uppercase. (Hint: Inside the loop, you can run `echo "$line" | tr '[:lower:]' '[:upper:]'`.)