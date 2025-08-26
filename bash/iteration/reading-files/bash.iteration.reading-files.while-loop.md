# problem: use a `while` loop to read a file line by line

`bash.iteration.reading-files.while-loop`

Problem text: You want to safely read each line from a file, even if the lines contain spaces or special characters.

## Solution

```bash
FILE="names.txt"

while IFS= read -r line; do
    echo "Name: $line"
done < "$FILE"
```

Technical discussion:

* `while ... done < "$FILE"` redirects the file into the loop so each line is read one at a time.
* `read -r` prevents backslashes from being treated as escape characters.
* `IFS=` ensures leading and trailing spaces are preserved (no automatic trimming).
* This method correctly handles **spaces, tabs, and special characters** in lines.
* Unlike the `for` loop, this approach is **safe and robust** for most real-world files.

## Discussion

* Decision processing: This is the standard way to process files line by line in bash.
* Other uses: Common in scripts that parse configuration files, logs, or structured text.
* Why care: Unlike the `for` loop, this approach will not “break” on spaces or odd characters, making it a professional-grade solution.

## practice question

Try the following challenges:

1. Create a file called `quotes.txt` with several quotes, some containing spaces.
   Write a script that prints each line prefixed with `Quote:` using a `while` loop.

2. Create a file called `numbers.txt` with numbers (one per line).
   Use a `while` loop to read the file and print only numbers greater than 10.
