
# Recipe: Setting Up Windows 11 Auditing via Group Policy

### Problem

You want to configure Windows 11 to log critical security events such as logons, file creation/deletion, and privilege use. By default, Windows does not audit many of these events, so you need to enable and tune Group Policy–based auditing.

---

### Solution

Use the **Local Group Policy Editor** to enable specific audit policies, then configure file and folder auditing for detailed event logging.

---

### Ingredients

* Windows 11 Pro or Enterprise edition
* Administrative privileges
* Access to the Local Group Policy Editor (`gpedit.msc`)
* Approximately 10–15 minutes of setup time

---

### Steps

#### 1. Open the Group Policy Editor

1. Press **Win + R**.
2. Type `gpedit.msc` and press **Enter**.
3. Approve the User Account Control prompt if required.

---

#### 2. Navigate to the Audit Policy Section

In the left-hand pane, expand the following path:

```
Computer Configuration
   → Windows Settings
      → Security Settings
         → Local Policies
            → Audit Policy
```

---

#### 3. Enable Core Audit Policies

Enable the following policies and select both **Success** and **Failure**:

| Policy                         | Purpose                                                                         |
| ------------------------------ | ------------------------------------------------------------------------------- |
| **Audit account logon events** | Logs domain or remote logons.                                                   |
| **Audit logon events**         | Logs local logons and logoffs.                                                  |
| **Audit object access**        | Enables file, folder, and registry auditing.                                    |
| **Audit privilege use**        | Records when privileged rights (e.g., administrative privileges) are exercised. |

To enable: double-click each entry → select **Define these policy settings** → check **Success** and **Failure** → click **OK**.

---

#### 4. Configure Object Access Auditing for Files and Folders

The “Audit object access” policy enables auditing, but you must specify which objects (files, folders) to audit.

To configure folder-level auditing:

1. In **File Explorer**, right-click the folder you want to monitor.
2. Select **Properties → Security → Advanced → Auditing tab**.
3. Click **Add**, then choose a **Principal** (for example, “Everyone” or a specific group).
4. Select **Success** and **Failure**.
5. Under permissions, choose relevant actions such as **Create files / write data**, **Delete**, or **Read**.
6. Click **OK** to confirm.

---

#### 5. Refresh the Group Policy

Open an elevated Command Prompt and run:

```cmd
gpupdate /force
```

This ensures the new policy settings are applied immediately.

---

#### 6. Verify Auditing in Event Viewer

Check that events are being logged:

1. Open **Event Viewer** (`eventvwr.msc`).
2. Navigate to:

   ```
   Windows Logs → Security
   ```
3. Review common event IDs:

   * **4624** – Successful logon
   * **4625** – Failed logon
   * **4663** – File accessed, created, or deleted
   * **4670** – File or folder permissions changed
   * **4672** – Privileged logon detected

You can create **custom filters** in Event Viewer to narrow results to specific event IDs or keywords.

---

### Discussion

Enabling these auditing settings provides detailed insight into user activity and privilege use on your system. However, the **Security log** can grow quickly, so you may need to adjust its size or overwrite settings:

* In **Event Viewer**, right-click **Security → Properties**.
* Configure the **Maximum log size** and **Overwrite events as needed**.

For enterprise environments, consider deploying these settings via **Group Policy Management Console (GPMC)** or using PowerShell scripts to automate configuration.
