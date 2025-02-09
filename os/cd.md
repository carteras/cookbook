# TL;DR `cd` Cookbook

## Introduction
The `cd` (change directory) command is used to navigate the file system in Linux. It allows users to move between directories efficiently.

---

## 1. **Basic Navigation**
### 🔹 Change to a specific directory
```sh
cd /path/to/directory
```

### 🔹 Move into a subdirectory
```sh
cd subdirectory
```

### 🔹 Move up one directory level
```sh
cd ..
```

### 🔹 Move up multiple levels
```sh
cd ../../
```

### 🔹 Go to the home directory
```sh
cd ~
```

### 🔹 Go to the previous directory
```sh
cd -
```

---

## 2. **Handling Hidden Directories**
### 🔹 Change into a hidden directory (starts with `.`)
```sh
cd .hidden_directory
```

---

## 3. **Handling Directories That Start with `-`**
### 🔹 Use `--` to stop option parsing
```sh
cd -- -directory
```

### 🔹 Use `./` to reference explicitly
```sh
cd ./-directory
```

---

## 4. **Using Absolute vs Relative Paths**
### 🔹 Absolute path (from root `/`)
```sh
cd /usr/local/bin
```

### 🔹 Relative path (from current location)
```sh
cd ../documents
```

---

## 5. **Navigating with Special Symbols**
### 🔹 Go to the home directory
```sh
cd ~
```

### 🔹 Go to the root directory
```sh
cd /
```

### 🔹 Return to the previous directory
```sh
cd -
```

---

## 6. **Using Tab Completion**
### 🔹 Auto-complete directory names
Press `Tab` after typing part of the directory name:
```sh
cd Doc<Tab>
```

---

## 7. **Handling Spaces in Directory Names**
### 🔹 Use quotes
```sh
cd "My Documents"
```

### 🔹 Escape spaces with `\`
```sh
cd My\ Documents
```

---

## 8. **Using `pushd` and `popd` for Directory Stacking**
### 🔹 Save current directory and switch
```sh
pushd /another/directory
```

### 🔹 Return to the previous directory
```sh
popd
```

---

## 9. **Troubleshooting & Help**
### 🔹 Verify the directory exists
```sh
ls -d directory_name
```

### 🔹 Check current directory
```sh
pwd
```

### 🔹 Get help
```sh
man cd
```

---

## Conclusion
The `cd` command is an essential tool for navigating the Linux file system. Mastering absolute and relative paths, hidden directories, and shortcuts will make movement across the system faster and more efficient!

