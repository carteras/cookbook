# Configuring the network to play locally 



## Concept

Our servers sit on two networks, and we need to gain access to our local network as well as keeping the other network available. 

We need to make sure that the local network is a real IP address (not behind NAT) so we can access it from other computers. 


## Goals

* Ensure that we have a virtual bridge available on our computer
* Set up our Virtual Machine to have a second network card using said bridge
* install dhcp client to get an IP address from our local network (10.13.37.1 ip.dnt.intranet)
* configure the second network card to turn on when booted and to use DHCP 

### At the end of this lesson yuou will be able to 

* add and configure additional network devices to virtual machines 
* install dhcp-client to the server
* create a ssh server that is accessible from cbrc.dnt.intranet network


## Glossary 

- systemctl is a command-line tool to inspect and control the systemd system and service manager.
- Virtual Bridge: A virtual bridge enables network connections from virtual machines to physical network cards, facilitating seamless data exchange
- DHCP: DHCP dynamically assigns IP addresses to devices on a network, simplifying connectivity and network management.
- dhclient :  automatically obtains IP configurations from a DHCP server, enabling network access for a device.
- systemd: systemd is a system and service manager for Linux, handling initialization and managing system processes.
- systemd-networkd: systemd-networkd configures network settings and manages network connections for systems using systemd.

## Instructions 

### Configure virt-manager 

#### Add Network Card

Before we can use both networks, we need to install a second network card onto our virtual machine. We do this by opening `virt-manager` and double clicking on your VM. 

![open virt-manager](os/images/image.png.png)


Click the little lightbulb and you will see the device manager for your Virtual Machine. 

![double click on your VM](os/images/image.png)


Look at the bottom of the window and you will see the Devices

![click add hardware](os/images/image-1.png)

Click Network

![add network card](os/images/image-2.png)

Select `Bridge device`  and choose `br0` (NOTE, do not bridge to eno1)

![select bridge and then write eno1](os/images/image-3.png)


Click finish

### Configure your server 

Load up your VM

#### Add add dhcp client 

Our server needs to install a DHCP client so it can get an IP for our internal network. Let's install it using `aptitude`. 

```bash
sudo apt install isc-dhcp-client
```

If prompted, press `y` to install.

#### Configure your new network card 

Next up we need to tell the server about this network card. We need to tell it that it needs to use DHCP. 

We can do this by creating a configuration file for the enp7s0 interface in the `/etc/systemd/network/` directory. You can name the file something like `enp7s0.network`.

However, you will need to make sure that you are using the right device. 

Type 

```bash
ip a
```

You should see 3 network devices 



```bash
sudo nano /etc/systemd/network/enp7s0.network
```

```plaintext
[Match]
Name=enp7s0

[Network]
DHCP=yes
```


```bash
sudo systemctl restart systemd-networkd
```