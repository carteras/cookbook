# problem: skip empty lines when reading a file

`bash.iteration.reading-files.skip-empty-lines`

Problem text: You want to process each line of a file, but some lines are blank. Instead of printing or working with empty lines, you want to ignore them.

## Solution

```bash
FILE="notes.txt"

while IFS= read -r line; do
    [ -z "$line" ] && continue
    echo "Note: $line"
done < "$FILE"
```

Technical discussion:

* `read -r line` reads one line at a time.
* `[ -z "$line" ]` checks if the variable is empty (`-z` means “zero length”).
* `continue` skips the rest of the loop body and jumps to the next iteration.
* This ensures only non-empty lines get processed.

## Discussion

* Decision processing: Adding a condition lets you filter out unwanted lines before doing work.
* Where else used: Useful in log files, CSV files, or config files where blank lines are common.
* Why care: It keeps your output clean and prevents wasting work on empty data.

## practice question

1. Create a file `cities.txt` with some city names and some blank lines. Write a script that prints only the cities, ignoring blanks.
2. Create a file `words.txt` with words, blank lines, and spaces. Write a script that prints `Word: <word>` for each non-empty line.
