# Using the `sort` Command in Linux

The `sort` command in Linux is used to arrange lines in a file or input **alphabetically, numerically, or based on custom criteria**.

---

## **Basic Syntax**
```
sort [options] [input_file] > [output_file]
```
- `[input_file]` → The file to be sorted.
- `[output_file]` → (Optional) File where sorted output is saved.
- `[options]` → Modifies sorting behavior.

By default, `sort` sorts **alphabetically** (A-Z).

---

## **1. Sorting a File Alphabetically**
```
sort file.txt
```
Sorts `file.txt` alphabetically and prints the result.

---

## **2. Saving Sorted Output to a New File**
```
sort file.txt > sorted.txt
```
Stores the sorted result in `sorted.txt`.

---

## **3. Sorting Numerically**
```
sort -n numbers.txt
```
Sorts based on numeric values instead of treating numbers as text.

Example (`numbers.txt`):
```
100
2
50
```
Sorted output:
```
2
50
100
```

---

## **4. Sorting in Reverse Order**
```
sort -r file.txt
```
Sorts in **descending order** (Z-A or highest to lowest for numbers).

---

## **5. Ignoring Case Sensitivity**
```
sort -f file.txt
```
Sorts text **without distinguishing uppercase and lowercase**.

Example (`file.txt`):
```
Banana
apple
Cherry
```
Sorted output:
```
apple
Banana
Cherry
```

---

## **6. Removing Duplicate Lines While Sorting**
```
sort -u file.txt
```
Sorts and removes duplicate lines.

---

## **7. Sorting by a Specific Column**
```
sort -k2 file.txt
```
Sorts based on the **second column** of the file.

Example (`file.txt`):
```
1 Apple
2 Banana
3 Cherry
```
Sorted output:
```
1 Apple
3 Cherry
2 Banana
```

---

## **8. Handling Files That Start with `-`**
```
sort -- -filename.txt
```
or
```
sort ./-filename.txt
```
Prevents `sort` from treating `-filename.txt` as an option.

---

## **Summary of Common Options**
| Command | Action |
|---------|--------|
| `sort file.txt` | Sort alphabetically (default). |
| `sort -r file.txt` | Sort in reverse order. |
| `sort -n file.txt` | Sort numerically. |
| `sort -f file.txt` | Ignore case sensitivity. |
| `sort -u file.txt` | Sort and remove duplicates. |
| `sort -kN file.txt` | Sort by the **N-th column**. |

With these commands, you can efficiently organize and manipulate text files in Linux! 🚀

