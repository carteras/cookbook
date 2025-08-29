# Problem: How can I detect if an image’s file extension is wrong using exiftool?

`exiftool.005.metadata.wrong-extension`

Sometimes files are given the wrong extension—intentionally (to evade detection) or accidentally (during renaming). For example, a malicious actor might rename an executable as `holiday.jpg`, or a `.png` might really contain JPEG data. Simply trusting the extension is risky; forensic checks must confirm the real file type.

## Solution

Use **exiftool** to identify the true file format by inspecting its internal signatures (magic numbers) and format-specific metadata.

```bash
# 1) Show the file type as identified by exiftool
exiftool -FileType -MIMEType suspicious.jpg

# 2) Display the full format information
exiftool -FileType -MIMEType -FileTypeExtension suspicious.jpg

# 3) Compare with the actual filename extension
ls -l suspicious.jpg   # or check manually against .jpg vs reported type

# 4) Run exiftool on a batch to find mismatches
exiftool -FileType -MIMEType -ext jpg . 
```

**Technical details:**

* `-FileType` shows the detected type (e.g., `JPEG`, `PNG`, `GIF`).
* `-MIMEType` adds an Internet-standard identifier (e.g., `image/jpeg`).
* `-FileTypeExtension` gives the recommended extension.
* If reported type ≠ filename extension → the file may be mislabeled, corrupted, or deliberately disguised.
* Exiftool relies on header signatures, not just the name, making it trustworthy for forensic checks.

## Discussion

* **Cybersecurity relevance:** Mismatched extensions are a common trick for phishing and malware delivery. Attackers may disguise executables or scripts as images/documents. Detecting discrepancies is critical in incident response.
* **Why students should care:** Blindly trusting file extensions is unsafe. This exercise builds awareness of file format validation—an essential skill for digital forensics and secure computing.
* **Broader patterns:** The same technique applies beyond images: PDFs, Office docs, and executables may all masquerade under false extensions. Always verify the actual content type before opening or trusting a file.

