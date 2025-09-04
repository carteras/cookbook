# Problem: How can I tell if an image was edited (vs. straight-from-camera) using exiftool?

`exiftool.006.metadata.edited-or-not`

Determining whether a photo was edited matters for verification and forensics. Edits often leave traces in metadata (software names, modified times, XMP history), or inconsistencies between “when taken” and “when modified.”

## Solution

Use **exiftool** to compare capture vs. modify times and look for editing/software tags and XMP edit history.

```bash
# 1) Compare capture vs. modify times
exiftool -DateTimeOriginal -CreateDate -ModifyDate image.jpg

# 2) Look for editor/software fingerprints
exiftool -Software -ProcessingSoftware -CreatorTool image.jpg

# 3) Check common XMP edit markers (history, workflow, derived-from)
exiftool -XMP-xmpMM:History -XMP-xmpMM:DerivedFrom -XMP:ModifyDate -XMP:MetadataDate image.jpg

# 4) Scan all metadata groups for edit clues (concise, with groups shown)
exiftool -a -G1 -s -time:all -XMP:All -IPTC:All -Photoshop:All image.jpg

# 5) Batch triage: list files where ModifyDate != DateTimeOriginal
exiftool -Directory -FileName -DateTimeOriginal -ModifyDate -if "$ModifyDate ne $DateTimeOriginal" .
```

**Technical details:**

* **Time mismatch:** If `ModifyDate` (or `XMP:ModifyDate`) is later than `DateTimeOriginal`, the file was likely edited or re-saved.
* **Software fingerprints:** `Software`, `ProcessingSoftware`, and `CreatorTool` often reveal editors (e.g., Photoshop, Lightroom, GIMP, Snapseed).
* **XMP workflow:** `xmpMM:History`, `xmpMM:DerivedFrom`, `xmpMM:DocumentID/InstanceID`, `MetadataDate` can show edit steps and lineage.
* **Platform stripping:** Some services strip EXIF but leave XMP; absence of EXIF with present XMP can itself be a clue.
* **Limitations:** Metadata can be removed or forged; use this as indicators, not absolute proof. Corroborate with pixel-level analysis, thumbnails, and container signatures.

## Discussion

* **Cybersecurity relevance:** Edit traces help validate evidentiary media, detect tampering, and reconstruct workflows during incident response and OSINT.
* **Why students should care:** Reading and comparing time/creator fields builds discipline in verifying authenticity rather than trusting appearances.
* **Broader patterns:** The “compare canonical vs. derived fields” method recurs in forensics across docs, logs, and archives—look for provenance fields, modify times, and tool fingerprints everywhere.
