# TL;DR `sort` Cookbook: A Beginner's Guide

## Introduction
The `sort` command is used to arrange lines of text files in a specified order. It supports sorting alphabetically, numerically, by column, and more.

---

## 1. **Basic Sorting**
### 🔹 Sort a file alphabetically (default behavior)
```sh
sort filename.txt
```

### 🔹 Sort and save the output to a new file
```sh
sort filename.txt > sorted.txt
```

---

## 2. **Sorting in Reverse Order**
### 🔹 Reverse the order of sorting
```sh
sort -r filename.txt
```

---

## 3. **Sorting Numerically**
### 🔹 Sort numbers correctly (instead of lexicographically)
```sh
sort -n numbers.txt
```

### 🔹 Sort numbers in descending order
```sh
sort -nr numbers.txt
```

---

## 4. **Sorting by Column**
### 🔹 Sort by the second column
```sh
sort -k2 filename.txt
```

### 🔹 Sort numerically by the second column
```sh
sort -k2,2n filename.txt
```

---

## 5. **Handling Special Files**
### 🔹 Sorting hidden files
```sh
sort .hiddenfile
```

### 🔹 Sorting files that start with `-`
```sh
sort -- -filename.txt
```

### 🔹 Sorting files with spaces in the name
```sh
sort "file with spaces.txt"
```

---

## 6. **Unique and Duplicate Lines**
### 🔹 Remove duplicate lines while sorting
```sh
sort -u filename.txt
```

### 🔹 Find duplicate lines
```sh
sort filename.txt | uniq -d
```

### 🔹 Count occurrences of each line
```sh
sort filename.txt | uniq -c
```

---

## 7. **Sorting Case-Insensitive**
### 🔹 Ignore case while sorting
```sh
sort -f filename.txt
```

---

## 8. **Sorting by Delimiter**
### 🔹 Sort using a custom delimiter (e.g., comma)
```sh
sort -t, -k2 filename.csv
```

---

## 9. **Randomizing Lines**
### 🔹 Shuffle lines randomly
```sh
sort -R filename.txt
```

---

## 10. **Sorting Files by Size, Time, or Other Metadata**
### 🔹 Sort files by size (using `ls` and `sort` together)
```sh
ls -l | sort -k5,5n
```

### 🔹 Sort files by modification time
```sh
ls -lt | sort -k6,6M -k7,7n -k8,8n
```

---

## 11. **Troubleshooting & Help**
### 🔹 Check file encoding
```sh
file filename.txt
```

### 🔹 Get help and options
```sh
man sort
```

---

## Conclusion
The `sort` command is essential for organizing text efficiently. Mastering its options allows for flexible and powerful sorting capabilities in Linux!

