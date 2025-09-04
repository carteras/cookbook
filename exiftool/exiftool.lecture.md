# Lecture: Introduction to ExifTool and Metadata Analysis


## 1. What is ExifTool?

**ExifTool** is a command-line utility created by Phil Harvey.  
It is widely used for **reading, writing, and editing metadata** in files.

- Supports **many formats** (images, videos, PDFs, Office docs, audio files, etc.)
- Handles **EXIF**, **IPTC**, **XMP**, and many other metadata standards
- Cross-platform: runs on Linux, macOS, and Windows

Think of ExifTool as a **microscope for file metadata** — it lets you see hidden information that isn’t visible when you just open the file.

---

## 2. What is Metadata?

Metadata = "data about data."

In the context of images and media, metadata can include:

- **Camera info:** make, model, lens, firmware
- **Timestamps:** when the photo was taken, created, modified
- **Location:** GPS coordinates (latitude, longitude, altitude)
- **Software history:** which editor or application touched the file
- **Embedded previews:** thumbnails or alternate images
- **Custom fields:** captions, comments, hidden notes

---

## 3. How Does ExifTool Work?

At its core, ExifTool:

1. **Reads the file header and metadata blocks**  
   - Many file types (JPEG, PNG, MP4, PDF) contain structured sections for metadata.  
   - ExifTool knows the formats and parses them.

2. **Interprets metadata tags**  
   - Different standards use different tag names (EXIF, IPTC, XMP).  
   - ExifTool unifies them into readable labels.

3. **Displays or modifies metadata on request**  
   - By default, ExifTool lists all tags it can find.  
   - You can also request specific tags (e.g., `-Artist` or `-GPSLatitude`).  
   - You can even edit metadata (`-Artist="Alice"`) — though in forensics, we usually only *read*.

---

## 4. Basic Usage

```bash
# Show all metadata in a file
exiftool file.jpg

# Request a specific field
exiftool -Artist file.jpg

# Multiple fields at once
exiftool -Make -Model -DateTimeOriginal file.jpg

# Numeric/raw output (e.g., decimal GPS)
exiftool -n -GPSLatitude -GPSLongitude file.jpg

# Save metadata to JSON or CSV
exiftool -json file.jpg > metadata.json
exiftool -csv -DateTimeOriginal -GPSLatitude -GPSLongitude *.jpg > out.csv
````

---

## 5. Why is ExifTool Important?

* **Forensics & Cybersecurity:** metadata can reveal hidden context, confirm authenticity, or expose tampering.
* **Privacy:** metadata may leak personal info (GPS location, device ID).
* **Digital asset management:** professionals use metadata for cataloging, searching, and rights management.

---

## 6. Key Concepts to Remember

* **Metadata lives inside files** — it doesn’t change the visible picture but carries critical context.
* **Not all fields are trustworthy** — they can be altered or stripped.
* **Always validate across multiple tags** (e.g., capture vs. modify time).
* **Batch power** — ExifTool can process entire folders with one command.

---

### Summary

ExifTool is a **powerful metadata toolkit**:

* It reads and interprets hidden information in files.
* It works across many formats and metadata standards.
* It is essential in forensics, OSINT, cybersecurity, and digital media workflows.

