

```bash
adam@awesomesauce:~$ nmap --version
Nmap version 7.92 ( https://nmap.org )
Platform: x86_64-redhat-linux-gnu
Compiled with: nmap-liblua-5.3.5 openssl-3.2.4 libssh2-1.11.1 libz-1.3.1.zlib-ng libpcre2-10.45 libpcap-1.10.5 nmap-libdnet-1.12 ipv6
Compiled without:
Available nsock engines: epoll poll select
adam@awesomesauce:~$ 
```

```bash
adam@awesomesauce:~$ sudo nmap localhost
[sudo] password for adam: 
Starting Nmap 7.92 ( https://nmap.org ) at 2025-07-29 15:39 AEST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.0000030s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 999 closed tcp ports (reset)
PORT    STATE SERVICE
631/tcp open  ipp

Nmap done: 1 IP address (1 host up) scanned in 0.11 seconds
adam@awesomesauce:~$ 
```

Find out what IP address your host computer (that's the real computer is) by going back to your desktop opening terminal and typing 

```bash
ip a | grep 10.13.37
```

You should see something like this: 

```bash
adam@fedora:~$ ip a | grep 10.13.37
    inet 10.13.37.233/24 brd 10.13.37.255 scope global dynamic noprefixroute enp0s3
adam@fedora:~$ 
```

Yours might be different... 

```bash
adam@fedora:~$ sudo nmap 10.13.37.200
Starting Nmap 7.92 ( https://nmap.org ) at 2025-07-29 15:44 AEST
Nmap scan report for 10.13.37.200
Host is up (0.00045s latency).
Not shown: 988 filtered tcp ports (no-response), 9 filtered tcp ports (admin-prohibited)
PORT     STATE  SERVICE
22/tcp   open   ssh
5901/tcp closed vnc-1
9090/tcp open   zeus-admin
MAC Address: 08:00:27:12:86:D8 (Oracle VirtualBox virtual NIC)

Nmap done: 1 IP address (1 host up) scanned in 5.14 seconds
adam@fedora:~$ 
```

Check bushranger `10.13.37.1` 

Instead of scanning all common ports you can focus. Let's scan the first 100

```bash
sudo nmap -p 1-100 TARGET_IP
```

By default, nmap hides a lot of information. Let's ask for verbose mode. 

```bash
sudo nmap -v TARGET_IP
```

You can get more information by doing more verbosity 

```bash
sudo nmap -vv TARGET_IP
```
You can attempt service detection 

```bash 
sudo nmap -sV TARGET_IP
```

You can save what you find. 

```bash
sudo nmap -oN results.txt TARGET_IP
```

We can go from secret mode to agressive. You can find some interesting things about computers using this mode 

```bash
sudo nmap -A TARGET_IP
```

`-A` turns on -sV service detection, and enables -O (operating systems detection, enables traceroute, can run some scripts)

If that's taking way too long, you can change the timing delay for failure to `-T4` 


```bash
sudo nmap -sV -T4 TARGET_IP
```


Scan an entire subnet

```bash
sudo nmap 10.13.37.0/24
```

This will scan all hosts from 10.13.37.0 to 10.13.37.255

Usually .0 is the network address and .255 is the broadcast address, so this should only report .1 to .254

nmap will only show hosts that respond. 

If you only want to see who's up

```bash
sudo nmap -sn 10.13.37.0/24
```

We can also scan a specific range 

```bash
sudo nmap -sn 10.13.37.0/24
```

This scans 30 addresses. 


But what if you only want to scan ports? 

```bash
sudo nmap -p 22,80 10.13.37.51-80
```

