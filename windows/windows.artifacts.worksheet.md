# STUDENT WORKSHEET: Windows Activity and Artifact Tracking

**Name:** _________________________  **Date:** ___________________

---

## Part A – System Actions

Perform the following actions in your virtual machine. Complete the table with the results from your investigation.

| # | Action                                                                  | Tool(s) Used                             | What Did You Find? (Describe or Record Event IDs, Timestamps, or File Paths) |
| - | ----------------------------------------------------------------------- | ---------------------------------------- | ---------------------------------------------------------------------------- |
| 1 | Log off and log back in                                                 | Event Viewer → Security Log              |                                                                              |
| 2 | Create, modify, and delete a text file                                  | File Explorer (timestamps), Recycle Bin  |                                                                              |
| 3 | Restore the deleted file from Recycle Bin                               | File Explorer                            |                                                                              |
| 4 | Install a simple program (e.g., 7-Zip)                                  | Event Viewer (Application Log), Registry |                                                                              |
| 5 | Run the installed program                                               | Prefetch folder (`C:\Windows\Prefetch`)  |                                                                              |
| 6 | Browse three websites (e.g., microsoft.com, wikipedia.org, example.com) | Browser history                          |                                                                              |

---

## Part B – Event Viewer Exploration

1. Open **Event Viewer** (`eventvwr.msc`).

   * Under **Windows Logs**, list the three primary categories:

     1. ---
     2. ---
     3. ---

2. Locate a **logon event** (Event ID 4624).

   * Time of logon: ______________________
   * User account: ______________________

3. Locate a **system shutdown or restart event** (Event ID 6006 or 6008).

   * Date/time: ______________________

---

## Part C – Registry Observation

1. Open **Registry Editor** (`regedit`).
2. Navigate to `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs`.

   * What kind of information do you see? _____________________________________
3. Navigate to `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall`.

   * Find the entry for the program you installed. What information is recorded? _____________________________________

---

## Part D – File Timestamps

1. Record the creation, modification, and access times for your test file:

| Timestamp Type | Date and Time |
| -------------- | ------------- |
| Created        |               |
| Modified       |               |
| Accessed       |               |

2. Edit and save the file again. Which timestamps changed? ____________________________

---

## Part E – Analysis Questions

1. Which tool provided the most detailed information about user logons?

   ---

2. How could you determine whether a program was run recently?

   ---

3. Why are timestamps and logs important in digital forensics?

   ---

4. Which artifacts would help prove that a file was deleted?

   ---