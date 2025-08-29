# Problem: How can I find out what camera model was used to take a picture with exiftool?

`exiftool.001.metadata.camera-model`

Digital images often contain EXIF metadata that records which camera (or device) was used to capture the photo. This information can help verify authenticity, trace origins, or identify the technology behind an image.

## Solution

Use **exiftool** to read the `Model` (and optionally `Make`) tags from the image metadata.

```bash
# Show the camera model
exiftool -Model photo.jpg

# Show both make (brand) and model
exiftool -Make -Model photo.jpg

# (Optional) See all metadata for deeper inspection
exiftool photo.jpg | grep -i model
```

**Technical details:**

* `-Model` displays the specific camera model (e.g., *Canon EOS 5D Mark III*).
* `-Make` shows the manufacturer (e.g., *Canon*).
* Not all images will retain this metadata — editing tools or social media platforms often strip it out.

## Discussion

* **Cybersecurity relevance:** Knowing the device that created a photo can aid digital forensics, OSINT, or detecting image tampering. For instance, multiple images claiming to be from different sources but showing the same camera model may suggest a connection.
* **Why students should care:** This teaches how hidden metadata can reveal device fingerprints, which can both aid investigations and pose privacy risks.
* **Broader patterns:** Similar methods apply to other file types — for example, documents may reveal the software or operating system used to create them. Recognizing metadata “device signatures” is an important step in analyzing digital evidence.
