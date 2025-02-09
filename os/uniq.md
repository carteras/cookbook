# Using the `uniq` Command in Linux

The `uniq` command in Linux is used to filter out **consecutive duplicate lines** from a sorted file or output.

---

## Basic Syntax
```
uniq [options] [input_file] [output_file]
```
- `[input_file]` → The file to process (optional; defaults to standard input).
- `[output_file]` → Save the result to a file (optional).

**Important:** `uniq` only removes **adjacent duplicates**, so you may need to sort the file first:
```
sort input.txt | uniq
```

---

## 1. Removing Duplicate Lines
```
uniq input.txt
```
Filters out consecutive duplicate lines from `input.txt` and prints the result.

---

## 2. Saving Output to a File
```
uniq input.txt output.txt
```
Writes the filtered result into `output.txt`.

---

## 3. Counting Duplicates
```
uniq -c input.txt
```
Shows the **number of occurrences** of each unique line.

Example:
```
3 apple
2 banana
1 cherry
```

---

## 4. Showing Only Duplicated Lines
```
uniq -d input.txt
```
Displays only lines that appear **more than once**.

---

## 5. Showing Only Unique Lines
```
uniq -u input.txt
```
Displays lines that appear **only once**.

---

## 6. Ignoring Case Sensitivity
```
uniq -i input.txt
```
Treats uppercase and lowercase as **the same**.

Example:
```
apple
Apple
```
Would be considered duplicates.

---

## 7. Comparing Only Certain Fields
```
uniq -f 2 input.txt
```
Ignores the first **two fields** (columns) when checking for duplicates.

---

## Summary
| Command | Action |
|---------|--------|
| `uniq file.txt` | Removes adjacent duplicates. |
| `uniq -c file.txt` | Counts occurrences. |
| `uniq -d file.txt` | Shows only duplicates. |
| `uniq -u file.txt` | Shows only unique lines. |
| `uniq -i file.txt` | Ignores case. |
| `uniq -f N file.txt` | Ignores the first N fields. |

With these commands, you can efficiently process duplicate lines in files! 🚀

