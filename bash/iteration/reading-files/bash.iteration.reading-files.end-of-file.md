# problem: stop reading when you reach end-of-file (EOF)

`bash.iteration.reading-files.end-of-file`

Problem text: You want your script to read every line until the file ends, and then finish cleanly without errors.

## Solution

```bash
FILE="grades.txt"

while IFS= read -r line; do
    echo "Grade: $line"
done < "$FILE"
```

Technical discussion:

* `read` returns **success (0)** while it reads a line; at **EOF it fails (non-zero)**, which ends the `while` loop.
* This pattern naturally stops at EOF—no manual counters needed.
* Edge case: if the final line lacks a trailing newline, `read` still yields that line once and then the next `read` hits EOF (loop ends).
* You can detect failures directly: `if ! IFS= read -r line; then echo "EOF reached"; fi`.

## Discussion

* Decision processing: Rely on `read`’s exit status to control the loop—simple and robust.
* Where else used: Any stream you can read from (files, pipelines, command output).
* Why care: Understanding EOF prevents infinite loops and makes scripts predictable.

## practice question

1. Make a file `numbers.txt` with several numbers (one per line). Write a script that reads all lines until EOF and prints `Done!` after the loop finishes.
2. Create a file `lastline-no-newline.txt` where the last line has **no** trailing newline (you can create it with `printf "A\nB"` so `B` has no newline). Write a script using the EOF loop above and confirm it still reads the final line before stopping.