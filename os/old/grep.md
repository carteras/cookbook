# TL;DR `grep` Cookbook: A Beginner's Guide

## Introduction
The `grep` command is used to search for patterns in files and output matching lines. It is a powerful tool for text processing in Linux.

---

## 1. **Basic Usage**
### 🔹 Search for a word in a file
```sh
grep "word" filename.txt
```

### 🔹 Search in multiple files
```sh
grep "word" file1.txt file2.txt
```

### 🔹 Search recursively in directories
```sh
grep -r "word" /path/to/directory
```

---

## 2. **Case-Insensitive Searches**
### 🔹 Ignore case while searching
```sh
grep -i "word" filename.txt
```

---

## 3. **Using Regular Expressions**
### 🔹 Match lines starting with a pattern
```sh
grep "^pattern" filename.txt
```

### 🔹 Match lines ending with a pattern
```sh
grep "pattern$" filename.txt
```

### 🔹 Match whole words only
```sh
grep -w "word" filename.txt
```

### 🔹 Use extended regex (for complex patterns)
```sh
grep -E "pattern1|pattern2" filename.txt
```

---

## 4. **Filtering Output**
### 🔹 Show only matching text (suppress filenames)
```sh
grep -o "pattern" filename.txt
```

### 🔹 Show line numbers with matches
```sh
grep -n "pattern" filename.txt
```

### 🔹 Show only count of matches
```sh
grep -c "pattern" filename.txt
```

---

## 5. **Searching for Hidden and Special Files**
### 🔹 Search in hidden files
```sh
grep "pattern" .hiddenfile
```

### 🔹 Search files that start with `-`
```sh
grep "pattern" -- -filename
```

### 🔹 Search files with spaces
```sh
grep "pattern" "file with spaces.txt"
```

---

## 6. **Recursive and Binary Searches**
### 🔹 Search recursively while ignoring binary files
```sh
grep -rI "pattern" /path/to/directory
```

### 🔹 Search in binary files
```sh
grep -a "pattern" binaryfile.bin
```

---

## 7. **Inverting Search (Find Lines That Do Not Match)**
### 🔹 Exclude lines matching a pattern
```sh
grep -v "pattern" filename.txt
```

---

## 8. **Combining Grep with Other Commands**
### 🔹 Find running processes
```sh
ps aux | grep process_name
```

### 🔹 Filter log files for errors
```sh
tail -f /var/log/syslog | grep "error"
```

### 🔹 Count occurrences of a word
```sh
cat filename.txt | grep -c "word"
```

---

## 9. **Using Grep with Piping**
### 🔹 Chain `grep` commands
```sh
cat file.txt | grep "error" | grep -v "debug"
```

---

## 10. **Troubleshooting & Help**
### 🔹 Check file encoding
```sh
file filename.txt
```

### 🔹 Get help and options
```sh
man grep
```

---

## Conclusion
The `grep` command is essential for searching text efficiently. Mastering its options and regular expressions will greatly enhance your ability to filter and process data in Linux!

