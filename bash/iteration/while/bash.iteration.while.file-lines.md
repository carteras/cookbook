# Problem: How can you read and print each line of a text file using a `while` loop?


We want to process the contents of a file line by line. The script should open a file, read one line at a time, and print it until all lines are processed.

## Solution

```bash
#!/bin/bash

filename="example.txt"

while IFS= read -r line
do
  echo "$line"
done < "$filename"
```

The `while` loop uses `read -r` to safely read a line of text (preventing backslash escapes). `IFS=` ensures leading/trailing spaces are preserved. The loop runs until the file has no more lines. The `< "$filename"` at the end redirects the file into the loop.

## Discussion

* **Why students should care about this?**
  Many real-world scripts need to process files line by line, especially configuration files, logs, or data files. This pattern is efficient and avoids loading the entire file into memory at once.

* **Where else this kind of logic might be used?**
  Line-by-line iteration is useful for parsing CSVs, scanning logs, reading lists of items to process, or transforming files into new formats. Any situation where structured text needs to be read step by step can use this method.

## Challenge

Write a script that:

1. Reads a file of names and prints them all in uppercase.
2. Then counts how many lines the file contains and prints the total at the end.

