# `strings`

**Description:**  
Extracts and prints readable text strings from binary files.

## Usage Examples:

- **Extract all printable strings from a binary file:**

```bash
  strings filename
```

Search for strings longer than a specific length (default is 4):

```bash
strings -n 8 filename
```


Display strings with their offsets (positions) in the file:

```bash
strings -t d filename  # Decimal offsets
strings -t x filename  # Hexadecimal offsets
```


Limit output to a specific encoding (e.g., ASCII or UTF-16):

```bash
strings -e l filename  # Little-endian UTF-16
```


Recursively search strings in all files within a directory:

```bash
strings -r /path/to/directory
```

