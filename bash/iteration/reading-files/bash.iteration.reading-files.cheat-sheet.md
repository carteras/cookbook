Perfect — here’s a **condensed cheat sheet** version of the lecture, just the essentials in Markdown.

````markdown
# Bash Reading Files Cheat Sheet

## Check if file exists
```bash
if [ -f "file.txt" ]; then
    echo "File exists"
fi
````

## For loop (simple, breaks on spaces)

```bash
for word in $(cat file.txt); do
    echo "$word"
done
```

## While loop (safe, recommended)

```bash
while IFS= read -r line; do
    echo "$line"
done < file.txt
```

## IFS splitting (custom separators)

```bash
# Example: CSV file "Alice,95"
IFS=, read -r name score < scores.csv
echo "$name scored $score"
```
