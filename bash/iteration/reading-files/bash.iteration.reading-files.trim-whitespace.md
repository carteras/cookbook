
# problem: trim whitespace around lines when reading a file

`bash.iteration.reading-files.trim-whitespace`

Problem text: You want to process lines from a file, but some lines have extra spaces or tabs at the beginning or end. You need a way to clean them up before using them.

## Solution

```bash
FILE="items.txt"

while IFS= read -r line; do
    # remove leading and trailing whitespace
    clean=$(echo "$line" | xargs)
    echo "Item: $clean"
done < "$FILE"
```

Technical discussion:

* `read -r line` reads each line exactly as written.
* `echo "$line" | xargs` strips leading and trailing whitespace (xargs trims by default).
* This ensures that `   apple   ` becomes `apple`.
* Alternatively, parameter expansion or tools like `sed` could be used, but `xargs` is simple and common.

## Discussion

* Decision processing: Decide if you want to preserve whitespace (default) or normalize it for easier handling.
* Where else used: Cleaning up messy data files, logs, or user input.
* Why care: Whitespace bugs are hard to spot — trimming ensures consistency when comparing or printing data.

## practice question

1. Create a file `shopping.txt` with lines like `   milk`, `eggs   `, and `   bread   `. Write a script that prints `Buy: <item>` for each item without leading/trailing spaces.
2. Create a file `mixed.txt` with some lines containing tabs or spaces at the ends. Write a script that prints only the cleaned-up version of each line.
