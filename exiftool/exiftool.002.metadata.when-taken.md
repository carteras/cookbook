# Problem: How can I find when a photo or video was taken using exiftool?

`exiftool.002.metadata.when-taken`

Knowing the true capture time helps verify timelines, check alibis, correlate events, or spot manipulation. Cameras, phones, and editors may store several time stamps; you want the original capture time, not just the file’s last-edited time.

## Solution

Use **exiftool** to read the primary capture-time tags (and fallbacks), and format them consistently.

```bash
# 1) Photos: show the most relevant capture-time fields
exiftool -DateTimeOriginal -CreateDate -ModifyDate photo.jpg

# 2) Videos (common containers): include QuickTime/MP4 metadata too
exiftool -DateTimeOriginal -CreateDate -ModifyDate -QuickTime:CreateDate -QuickTime:ModifyDate clip.mp4

# 3) See ALL time-related fields to compare (photo or video)
exiftool -time:all -a -G1 -s mediafile

# 4) Normalize output format for easy comparison
exiftool -DateTimeOriginal -CreateDate -ModifyDate -d "%Y-%m-%d %H:%M:%S%z" mediafile

# 5) If device stored local time but QuickTime times are UTC (common on iOS videos),
# exiftool can interpret as UTC for display:
exiftool -api QuickTimeUTC -QuickTime:CreateDate -QuickTime:ModifyDate clip.mov
```

**Technical details:**

* **`DateTimeOriginal`** is the usual “when taken” for photos. **`CreateDate`** is often a close fallback; **`ModifyDate`** is last edit time (not capture time).
* For **videos**, QuickTime/MP4 atoms may hold **`QuickTime:CreateDate`** in UTC; `-api QuickTimeUTC` displays them as UTC to avoid misleading local offsets.
* `-time:all -a -G1 -s` shows every time tag, avoids deduping, and prefixes each with its group, so you can see where a value comes from.
* File system timestamps (e.g., `ls -l`) are unreliable for capture time—always prefer embedded metadata.
* Social platforms and some editors may strip or rewrite times; comparing multiple tags helps detect that.

## Discussion

* **Cybersecurity relevance:** Accurate timelines are critical in incident response and digital forensics. Capture-time metadata helps correlate images/videos with logs, access records, or location data, and can expose attempts to backdate or forward-date evidence.
* **Why students should care:** Understanding which timestamps matter—and how they drift across formats and time zones—prevents bad conclusions in reports and investigations.
* **Broader patterns:** The “many clocks” problem recurs across file types (docs, archives, logs). The workflow of checking canonical fields first, then enumerating all time tags, generalizes to any metadata-led verification task.
