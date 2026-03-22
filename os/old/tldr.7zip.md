# TL;DR: Using p7zip on Fedora


## Unzip a 

```bash
# Unzip a .7z File with full path
7za x archive.7z

# Lists contents without extracting.
7za l archive.7z

#Extracts encrypted files (replace YourPassword with the actual password).
7za x archive.7z -pYourPassword


#Extracts a single file without full paths.
7za e file.gz

```

Summary

* `7za x`: Extract with full paths.
* ` 7za l`: List contents.
* `7za x `-pPassword: Extract encrypted archives.
* `7za e`: Extract without full paths (single files).