
# Problem: How can I see who the artist or creator of an image is using exiftool?

When you find or receive an image, it can be useful to check its embedded metadata to see if the creator (artist, photographer, or software author) is listed. This information can be hidden inside the file’s EXIF tags, but isn’t immediately visible when you just open the image.

## Solution

Use the command-line tool **exiftool** to extract the **Artist/Creator** fields from the image metadata.

```bash
# Check just the Artist field
exiftool -Artist myphoto.jpg

# Check Artist, Creator, and By-line fields
exiftool -Artist -Creator -By-line myphoto.jpg

# (Optional) View all metadata and search for artist-related fields
exiftool myphoto.jpg | grep -i artist
```

These commands query the image file (`myphoto.jpg`) for tags that may identify who created it.

**Technical details:**

* `-Artist`, `-Creator`, and `-By-line` are common metadata tags that different cameras, editors, and systems may use.
* `grep -i` filters for lines containing “artist,” case-insensitive. (On Windows, you can just run `exiftool myphoto.jpg` and search manually.)
* If the fields are empty, the information was never embedded, or it has been stripped out.

## Discussion

* **Cybersecurity relevance:** Metadata can reveal sensitive information — such as author names, device IDs, or locations. Attackers and investigators alike use tools like `exiftool` to trace the origins of media.
* **Why students should care:** Understanding how to inspect metadata helps with digital forensics, OSINT (open-source intelligence), and privacy awareness. It teaches you to think beyond the visible content of files.
* **Broader patterns:** This method is not limited to images; the same pattern applies to documents (Word, PDF) and videos. Metadata analysis is a recurring skill in security investigations, digital rights management, and privacy audits.
