# problem: use a `for` loop to read a file line by line

`bash.iteration.reading-files.for-loop`

Problem text: You want to read each line from a file and do something with it, like print the line or process the text.

## Solution

```bash
FILE="names.txt"

for line in $(cat "$FILE"); do
    echo "Name: $line"
done
```

Technical discussion:

* `$(cat "$FILE")` substitutes the file contents into the loop.
* The `for` loop splits text on **whitespace** (spaces, tabs, newlines).
* This means lines with spaces (e.g., `Mary Jane`) will be split into two separate words.
* This method works fine for simple files, but can break when lines contain spaces or special characters.

## Discussion

* Decision processing: This is the simplest way to loop over file content, but it comes with limitations.
* Other uses: `for` loops are also useful for iterating over filenames, command arguments, or simple lists.
* Why care: Understanding this version helps students see why the `while read` loop (covered next) is often preferred for real-world scripts.

## practice question

Try the following challenges:

1. Create a file called `fruits.txt` with one fruit per line.
   Write a script that prints `I like <fruit>` for each fruit using a `for` loop.

2. Create a file called `animals.txt` with animal names, some with spaces (e.g., `polar bear`).
   Run your script on it and note what happens. Explain why the behavior is different compared to `fruits.txt`.
