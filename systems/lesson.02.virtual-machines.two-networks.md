# Lesson 2: Adding a Second Network Card to Your VM

## Concept

Right now your VM has one network connection — a **NAT** connection. NAT (Network Address Translation) means your VM hides behind your host computer's IP address, like a device behind a home router. It can reach the internet, but other computers on the network can't easily reach it directly.

For our classroom setup we want your VM to have **its own IP address** on the local network — just like a real server would. To do this we add a second network card connected to a **bridge**, which gives the VM a direct presence on the local network.

Think of it like this:

```
WITHOUT BRIDGE (NAT only):
  Internet ──► Host PC (192.168.1.10) ──► VM (hidden, no direct address)
                                           Other PCs CAN'T reach the VM directly

WITH BRIDGE:
  Local Network ──► Host PC ──┬── Host's own connection (192.168.1.10)
                              └── VM (192.168.1.XX) ← VM has its OWN address
                                   Other PCs CAN reach the VM directly
```

## Goals

- Add a second virtual network card to your VM
- Connect it to the local network via a bridge (`br0`)
- Configure the VM to automatically get an IP address on boot
- Verify you can SSH in from another machine using the new address

## At the End of This Lesson You Will Be Able To

- Add hardware to an existing VM in `virt-manager`
- Understand the difference between NAT and bridged networking
- Write a `systemd-networkd` network configuration file
- Connect to your VM from another computer on the local network

## Glossary

| Term | Meaning |
|------|---------|
| **NAT** | Network Address Translation — VM shares the host's IP, hidden from the network |
| **Bridge** | A virtual switch connecting the VM directly to the physical network |
| **br0** | The name of the bridge device we'll use (set up by your instructor) |
| **DHCP** | Dynamic Host Configuration Protocol — automatically assigns IP addresses |
| **dhclient** | A program that requests an IP address from a DHCP server |
| **enp1s0** | First network card name (yours may differ — check with `ip a`) |
| **enp7s0** | Second network card name (yours may differ — check with `ip a`) |
| **systemd-networkd** | The network management service in Fedora Server |
| **NIC** | Network Interface Card — a network card |

---

## Part 1: Check That the Bridge Exists on Your Host

Before adding the second network card, let's confirm the bridge `br0` is available on your host machine.

On your **host machine**, open a terminal:

```bash
ip link show br0
```

You should see something like:

```
4: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP ...
```

If you get `Device "br0" does not exist`, speak to me — the bridge needs to be created first.

> ⚠️ **Do NOT bridge to `eno1` (or `eth0`) directly.** Always use `br0`. Bridging directly to a physical NIC can cause network problems for the whole classroom.

---

## Part 2: Add a Second Network Card in virt-manager

### Step 2.1 — Open the VM Hardware Details

Open `virt-manager`. Find your VM in the list, but **don't start it yet** (or shut it down if it's running — `sudo shutdown now` inside the VM).

Double-click on your VM name to open its console window.

### Step 2.2 — Open Hardware Details

Click the **lightbulb icon** (or "Show virtual hardware details") in the toolbar. This is the hardware manager for your VM.

```
┌────────────────────────────────────────────────────────────┐
│  [VM Name] on QEMU/KVM                                     │
│  ┌──────────────────────────┐                              │
│  │  Overview                │   Toolbar:                   │
│  │  OS Information          │   [▶ Start] [💡 Details]     │
│  │  Performance             │             ↑ Click this     │
│  │  CPUs                    │                              │
│  │  Memory                  │                              │
│  │  Boot Options            │                              │
│  │  ─────────────────────   │                              │
│  │  IDE Disk 1              │                              │
│  │  IDE CDROM 1             │                              │
│  │  NIC :xx:xx:xx (virtio)  │  ← Your first network card  │
│  │  ─────────────────────   │                              │
│  │  [ Add Hardware ]        │  ← Click this                │
│  └──────────────────────────┘                              │
└────────────────────────────────────────────────────────────┘
```

### Step 2.3 — Add Hardware

Click **"Add Hardware"** at the bottom of the left panel.

A dialog will appear. Click **Network** in the left list.

```
┌────────────────────────────────────────────────────────────┐
│  Add New Virtual Hardware                                  │
├────────────────────────────────────────────────────────────┤
│  Storage       │  Network source:                          │
│  Controller    │  [ Bridge device...              ▼ ]      │
│  Network   ◄── │                                           │
│  Input         │  Device name:  [ br0             ]        │
│  Graphics      │                                           │
│  Sound         │  Device model: [ virtio           ▼ ]     │
│  ...           │                                           │
│                │  [ Cancel ]  [ Finish ]                   │
└────────────────────────────────────────────────────────────┘
```

Configure it like this:

- **Network source**: Select **"Bridge device..."**
- **Device name**: Type `br0`
- **Device model**: Leave as `virtio` (it's fast and Fedora supports it natively)

Click **Finish**.

> 📌 **IMAGE PLACEHOLDER**  
> *Screenshot needed: virt-manager "Add New Virtual Hardware" dialog with Network selected, "Bridge device" chosen, and "br0" typed in the device name field*

You should now see a second NIC in the hardware list on the left.

---

## Part 3: Boot Your VM and Identify the New Network Card

### Step 3.1 — Start the VM

Click the **Start** button (▶) to boot your VM, then log in.

### Step 3.2 — Find the New Network Card

```bash
ip a
```

You'll now see three network interfaces:

```
1: lo: <LOOPBACK,UP,LOWER_UP>
    inet 127.0.0.1/8

2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 192.168.122.XX/24          ← Your original NAT card (still works)

3: enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP>
                                    ← Your NEW bridged card (no IP yet!)
```

The new card is the one **without an IP address**. Note its name (it might be `enp7s0`, `enp2s0`, or something else — use whatever `ip a` shows you).

> 💡 **Card names** are based on the physical slot the card is in. `enp7s0` means "Ethernet, PCI bus 7, slot 0". Your number might be different.

---

## Part 4: Configure the New Network Card

We need to tell Fedora to use DHCP on the new card so it automatically gets an IP address from the classroom network.

Fedora Server uses `systemd-networkd` to manage network connections. We configure it by creating a small text file.

### Step 4.1 — Install dhcp-client

```bash
sudo dnf install -y dhcp-client
```

### Step 4.2 — Create the Network Configuration File

Replace `enp7s0` in the filename and config with **your actual interface name** (from the `ip a` output above).

```bash
sudo nano /etc/systemd/network/enp7s0.network
```

Type the following into the file:

```ini
[Match]
Name=enp7s0

[Network]
DHCP=yes
```

- `[Match]` — tells systemd-networkd which card this config applies to
- `Name=enp7s0` — match by the interface name (change this to your actual name!)
- `DHCP=yes` — automatically request an IP address when the card comes up

Press **Ctrl+S** to save, then **Ctrl+X** to exit.

### Step 4.3 — Enable and Restart systemd-networkd

```bash
sudo systemctl enable --now systemd-networkd
sudo systemctl restart systemd-networkd
```

### Step 4.4 — Request an IP Address

This should just magically happen after added a second network card

---

## Part 5: Make It Persistent Across Reboots

The `dhclient` command above only lasts until you reboot. Because we already created the `systemd-networkd` config file, the interface should come up automatically on boot. Let's verify.

### Step 5.1 — Reboot and Check

```bash
sudo reboot
```

After the reboot, log back in and check:

```bash
ip a
```

---

## Part 6: Open the Firewall on the New Interface

NOTE: You may not need this

Fedora's firewall needs to know to allow SSH traffic on the new interface. Tell it the new interface is in the "public" zone (which allows SSH by default):

```bash
sudo firewall-cmd --permanent --zone=public --add-interface=enp7s0
sudo firewall-cmd --reload
```

---

## Part 7: Test Connecting from Another Machine

Ask a classmate to SSH into your VM using your new IP address, or try it from your host:

```bash
ssh yourusername@10.13.37.XX -p 22
```

If it works, your VM now has a real presence on the local network. 🎉

---

## Summary

Your VM now has two network cards:

| Card | Type | Address | Use |
|------|------|---------|-----|
| `enp1s0` | NAT | `192.168.122.x` | Internet access for your VM |
| `enp7s0` | Bridge | `10.13.37.x` | Access from other machines on the local network |

In the next lessons, we'll start working with users, files, and permissions inside your VM.