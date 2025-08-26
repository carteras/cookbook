# problem: handle lines with spaces correctly when reading a file

`bash.iteration.reading-files.handle-spaces`

Problem text: You want to read and print lines from a file where some lines contain spaces (like `New York` or `ice cream`). You need to make sure the line is kept whole instead of splitting at spaces.

## Solution

```bash
FILE="places.txt"

while IFS= read -r line; do
    echo "Place: $line"
done < "$FILE"
```

Technical discussion:

* Without special care, `for line in $(cat file)` splits on whitespace (breaking up lines with spaces).
* Using `while IFS= read -r line` preserves the line exactly, including spaces and tabs.
* Quoting `"$line"` when you use it ensures the shell doesn’t split it again.
* This makes the `while read` approach the correct way to handle lines that may contain spaces.

## Discussion

* Decision processing: You choose `while read` instead of `for` when data may include spaces.
* Where else used: Reading names, addresses, or sentences — anything that can include spaces.
* Why care: Many real-world files contain spaces, and handling them properly avoids subtle bugs.

## practice question

1. Create a file `bands.txt` with names like `The Beatles`, `Pink Floyd`, and `ACDC`. Write a script that prints `Band: <name>` while keeping the spaces intact.
2. Create a file `foods.txt` with items like `ice cream`, `apple pie`, and `pasta`. Write a script that prints each food correctly, showing that lines with spaces are handled as one piece.
