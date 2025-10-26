Nice — I’ll walk you through a practical, safe-forensics tutorial to analyze your Windows 11 `qcow2` image from Kali Linux using Autopsy (plus some Sleuth Kit / qemu tools). I’ll give you actionable commands, what each step does, and tips for common forensic tasks (hashing, mounting read-only, timeline, extracting files, using Autopsy GUI). Treat the image as evidence — always work on copies and keep hashes.

---

# Quick overview (what we’ll do)

1. Prepare Kali: install Autopsy, sleuthkit and qemu tools.
2. Make a forensic copy & compute hashes (preserve integrity).
3. Either convert the `qcow2` to a raw image **or** attach it read-only via `qemu-nbd`.
4. Map and mount Windows partitions read-only (if you need file-level access).
5. Add the image to Autopsy and run typical investigations (file system, registry, timeline, searches).
6. Use SleuthKit CLI tools for extra tasks (timeline, carve, extract by inode).
7. Export results and keep chain-of-custody notes.

---

# 0) Preliminaries / safety

* Work on copies, never on the original `qcow2`.
* Perform all mounts read-only. Use `-r` options where available.
* Run everything as a dedicated forensic user or root in a controlled VM.
* Record timestamps and hashes before and after any conversion or attachment.

---

# 1) Install required packages on Kali

Open a terminal and run:

```bash
sudo apt update
sudo apt install -y autopsy sleuthkit qemu-utils qemu-guest-agent libguestfs-tools kpartx
```

What these provide:

* `autopsy` — GUI forensic platform.
* `sleuthkit` — command-line tools (`mmls`, `fls`, `icat`, `blkcat`, `ils` etc.).
* `qemu-utils` — `qemu-img`, `qemu-nbd` for qcow2 handling.
* `kpartx` / `libguestfs-tools` — partition mapping and guestfs helpers.

---

# 2) Make a working copy and compute hashes

Assume your original is `win11_orig.qcow2`. Make a copy and hash both original and copy:

```bash
# make a copy (on same host — ideally to separate storage)
cp -v win11_orig.qcow2 work_win11.qcow2

# compute hashes (record these)
md5sum win11_orig.qcow2 work_win11.qcow2
sha256sum win11_orig.qcow2 work_win11.qcow2
```

Record hash values (this is your evidence integrity record).

---

# 3A) Option A — Convert qcow2 → raw (recommended if you want a single-file image Autopsy handles reliably)

Converting to raw gives broad compatibility (Autopsy/SleuthKit accept raw). This can take a while depending on image size:

```bash
# convert to raw (progress shown with -p)
qemu-img convert -p -O raw work_win11.qcow2 work_win11.raw
# compute hash of the raw image
md5sum work_win11.raw
sha256sum work_win11.raw
```

Now you can add `work_win11.raw` to Autopsy as an image file.

---

# 3B) Option B — Attach qcow2 read-only with qemu-nbd (no conversion)

If you prefer not to convert (saves disk space/time), attach the qcow2 as a block device read-only:

```bash
# load nbd kernel module (if not already)
sudo modprobe nbd max_part=16

# connect qcow2 read-only to /dev/nbd0
sudo qemu-nbd --connect=/dev/nbd0 --readonly work_win11.qcow2

# check partitions
sudo fdisk -l /dev/nbd0
# or
lsblk /dev/nbd0
```

Record output showing partitions (e.g. `/dev/nbd0p1`, `/dev/nbd0p2`, ...).

To map partitions to /dev/mapper, use kpartx:

```bash
sudo kpartx -av /dev/nbd0
# this creates /dev/mapper/nbd0p1, nbd0p2, ...
ls -l /dev/mapper/nbd0p*
```

When done, to cleanly detach:

```bash
sudo kpartx -d /dev/nbd0
sudo qemu-nbd --disconnect /dev/nbd0
```

Important: use `--readonly` (or `-r`) when connecting to avoid writes.

---

# 4) (Optional) Mount a Windows partition read-only to inspect files directly

Find which partition contains `Windows` (usually the large NTFS partition). Example:

```bash
# identify partition number from fdisk or lsblk, assume /dev/mapper/nbd0p2 is the main Windows partition
sudo mkdir -p /mnt/win11_p2
sudo mount -o ro,noload /dev/mapper/nbd0p2 /mnt/win11_p2    # noload avoids journal replay
ls -la /mnt/win11_p2/Windows
```

`noload` prevents replaying NTFS journal (keeps read-only). When finished:

```bash
sudo umount /mnt/win11_p2
```

---

# 5) Start Autopsy and create a case

Run Autopsy:

```bash
# run autopsy (it opens a web UI at http://localhost:9999)
autopsy &
# or (if autopsy isn't in PATH)
sudo autopsy &
```

Open a browser on the Kali machine at `http://localhost:9999` (Autopsy runs a local web UI).
GUI steps (high-level):

1. Click **Create New Case** → give a case name, examiner name, location to store results.
2. After case created, click **Add Host** (optional) then **Add Data Source**.
3. Choose **Image File** and point to your evidence image:

   * If you converted: select `work_win11.raw`.
   * If you attached qcow2 via `/dev/nbd0`: you can use **Add Data Source → Local Disk or Device** and point to `/dev/nbd0` or supply the raw file path — Autopsy generally prefers image files, so conversion is simpler.
4. Let Autopsy ingest the image (it will parse partitions, file systems, index files).

During add-data-source you can choose ingest modules (hash lookup, file type identification, e-mail parsing, keyword search, timeline, etc.). Enable modules you need (Registry, Browser History, MFT, Windows event logs, EXIF, etc).

---

# 6) Useful Sleuth Kit / CLI commands (parallel to Autopsy)

Even if you use Autopsy, CLI is handy.

List partition layout (for raw or block device):

```bash
mmls work_win11.raw          # or mmls /dev/nbd0
```

Show filesystem metadata and list files recursively (produce bodyfile for timeline):

```bash
# Create bodyfile for timeline (recursive)
fls -r -m / work_win11.raw > bodyfile.txt
# Then create mactime timeline (requires mactime or python replacement)
mactime -b bodyfile.txt > timeline.txt
```

Extract file by inode (get file from image):

```bash
# find inodes with ils or by using fls output; assume inode 123456
icat work_win11.raw 123456 > extracted_file.bin
```

Dump the $MFT (NTFS Master File Table) with `tsk_recover` or `icat`. To list deleted entries, use `fls -r -d`.

Carve unallocated space with `foremost` or `scalpel` if installed.

---

# 7) Common investigative targets inside Autopsy

* **User accounts & user directories**: `C:\Users\` — Documents, Desktop, Downloads.
* **Registry hives**: `C:\Windows\System32\config\` (SYSTEM, SOFTWARE) and user `NTUSER.DAT` in each user profile — Autopsy parses many registry artifacts (running apps, installed programs, autostart).
* **Browser history / cookies**: Chrome, Edge, Firefox locations under user profiles — Autopsy has parsers.
* **Event logs**: `C:\Windows\System32\winevt\Logs\` — Autopsy can parse event logs.
* **Prefetch**, **ShimCache**, **LNK files**, **USN Journal**: helpful for execution and file timeline.
* **$MFT** timeline and file slack / deleted file recovery**.
* **Scheduled tasks**, **services**, **installed programs**, **RDP/remote access artifacts**.

Autopsy modules and views let you search for keywords, view extracted artifacts, and build timelines. Use the Keyword Search and Timeline modules to correlate events.

---

# 8) Example: create a simple timeline with SleuthKit (if you used raw)

Generate bodyfile and convert to mactime format:

```bash
# list all file entries recursively and output bodyfile compliant data
fls -r -m / work_win11.raw > bodyfile

# generate timeline (mactime)
mactime -z UTC -b bodyfile > timeline.csv
# open timeline.csv in a spreadsheet or tail it
head -n 200 timeline.csv
```

Autopsy also provides a Timeline module with a GUI to visualize activity.

---

# 9) Exporting results from Autopsy

Autopsy lets you export: file lists, extracted artifacts, reports (HTML). In the case workspace, use **Generate Report** and select the artifact types to include, or export specific files from the Results pane. Always record the export hashes and time.

---

# 10) Clean up (very important)

If you attached the image with `qemu-nbd` or used `kpartx`, detach and remove mappings:

```bash
sudo umount /mnt/win11_p2        # if mounted
sudo kpartx -d /dev/nbd0
sudo qemu-nbd --disconnect /dev/nbd0
sudo modprobe -r nbd             # optional: remove module
```

---

# 11) Troubleshooting tips

* If Autopsy cannot read a `qcow2` directly, convert to raw first.
* If `mount` fails on NTFS, use `ntfs-3g` or use `-o ro,noload`.
* If `qemu-nbd` says device busy, ensure no partition mappings are mounted.
* For very large images, ensure you have enough storage for conversion or work directly via `qemu-nbd`.

---

# 12) Short checklist to get started (copy-paste)

```bash
# 1. Install
sudo apt update
sudo apt install -y autopsy sleuthkit qemu-utils libguestfs-tools kpartx

# 2. Copy & hash
cp win11_orig.qcow2 work_win11.qcow2
md5sum work_win11.qcow2
sha256sum work_win11.qcow2

# 3. (recommended) Convert to raw
qemu-img convert -p -O raw work_win11.qcow2 work_win11.raw
md5sum work_win11.raw
sha256sum work_win11.raw

# 4. Start autopsy and add work_win11.raw
autopsy &

# 5. (optional) SleuthKit timeline
fls -r -m / work_win11.raw > bodyfile
mactime -b bodyfile > timeline.txt
```

---

