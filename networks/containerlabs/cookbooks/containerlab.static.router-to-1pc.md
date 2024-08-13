# Set router with single static network

We are going to learn how to route between two networks. To do this we are going to create the following topology. 

![alt text](image.png)

But first, let's kill any clab instances on our machine 

```bash
sudo containerlab destroy -a
```

## Create a topology file

Create a new working directory and make a new topology file in there. 

```bash
mkdir ~/<whatever.your.working.directory.is.called>/clab/routing1pc -p
cd ~/<whatever.your.working.directory.is.called>/clab/routing1pc
touch topology.yml
```

Now either open that file in visual studio code or use nano to edit

```bash
nano topology.yml
```

```yaml
name: test-router-static
topology:
  nodes:
    r1:
      kind: linux
      image: frrouting/frr:latest

    workstation1:
      kind: linux
      image: alpine:latest

    test:
      kind: linux
      image: reverse-ctf-server
      ports:
        - "2222:22/tcp"
  links: 
    - endpoints: ['r1:eth1', 'test:eth1']
    - endpoints: ['r1:eth2', 'workstation1:eth1']
```

and then build 

```bash
sudo containerlab deploy -t topology.yml
```

## Configuration

Let's have a look

```bash
adam@fedora:~/nerdstuff/clabs/clab.test/1router1network$ sudo containerlab inspect -a 
[sudo] password for adam: 
+---+--------------+--------------------+--------------------------------------+--------------+----------------------+-------+---------+----------------+----------------------+
| # |  Topo Path   |      Lab Name      |                 Name                 | Container ID |        Image         | Kind  |  State  |  IPv4 Address  |     IPv6 Address     |
+---+--------------+--------------------+--------------------------------------+--------------+----------------------+-------+---------+----------------+----------------------+
| 1 | topology.yml | test-router-static | clab-test-router-static-r1           | 3f477de258f5 | frrouting/frr:latest | linux | running | 172.20.20.3/24 | 2001:172:20:20::3/64 |
| 2 |              |                    | clab-test-router-static-test         | 77235941d099 | reverse-ctf-server   | linux | running | 172.20.20.2/24 | 2001:172:20:20::2/64 |
| 3 |              |                    | clab-test-router-static-workstation1 | 89f0c8f926ee | alpine:latest        | linux | running | 172.20.20.4/24 | 2001:172:20:20::4/64 |
+---+--------------+--------------------+--------------------------------------+--------------+----------------------+-------+---------+----------------+----------------------+
```

Right, so it is probably best to start with the router


```bash
sudo docker exec -it clab-test-router-static-r1 vtysh
```

Now we have hopped on the router, let's configure it all up. Remember we need to set up two ethernet ports, eth1 and eth2

```sh
r1# configure terminal
r1(config)# interface eth
eth0  eth1  eth2  
r1(config)# interface eth1 
r1(config-if)# ip address 10.0.0.1/24
r1(config-if)# interface eth2
r1(config-if)# ip address 10.0.1.1/24
r1(config-if)# end
r1# show interface brief
Interface       Status  VRF             Addresses
---------       ------  ---             ---------
eth0            up      default         172.20.20.3/24
                                        + 2001:172:20:20::3/64
eth1            up      default         10.0.0.1/24
eth2            up      default         10.0.1.1/24
lo              up      default 
```

Let's make sure that the router knows that it needs to route stuff. 

```sh
r1# show ip route
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

K>* 0.0.0.0/0 [0/0] via 172.20.20.1, eth0, 00:02:35
C>* 10.0.0.0/24 is directly connected, eth1, 00:01:12
C>* 10.0.1.0/24 is directly connected, eth2, 00:00:52
C>* 172.20.20.0/24 is directly connected, eth0, 00:02:35
```

Hey, look at that, both 10.0.0.0 and 10.0.1.0 are up there ready to go. The `C` means that they are physically connected to the machine. 

Let's finish up by writing memory and exiting

```bash
write memory
exit
```

Let's check our names again. 


```bash
sudo containerlab inspect -a
+---+--------------+--------------------+--------------------------------------+--------------+----------------------+-------+---------+----------------+----------------------+
| # |  Topo Path   |      Lab Name      |                 Name                 | Container ID |        Image         | Kind  |  State  |  IPv4 Address  |     IPv6 Address     |
+---+--------------+--------------------+--------------------------------------+--------------+----------------------+-------+---------+----------------+----------------------+
| 1 | topology.yml | test-router-static | clab-test-router-static-r1           | 3f477de258f5 | frrouting/frr:latest | linux | running | 172.20.20.3/24 | 2001:172:20:20::3/64 |
| 2 |              |                    | clab-test-router-static-test         | 77235941d099 | reverse-ctf-server   | linux | running | 172.20.20.2/24 | 2001:172:20:20::2/64 |
| 3 |              |                    | clab-test-router-static-workstation1 | 89f0c8f926ee | alpine:latest        | linux | running | 172.20.20.4/24 | 2001:172:20:20::4/64 |
+---+--------------+--------------------+--------------------------------------+--------------+----------------------+-------+---------+----------------+----------------------+


```

I choose to log onto my test user but you could go the other way

```bash
sudo docker exec -it clab-test-router-static-test sh
```

Let's set up the machine

```bash
apk update
apk add iproute2

ip addr add 10.0.0.50/24 dev eth1 
ip link set eth1 up
```

Right, let's fix the routing table

```sh
ip route show
default via 172.20.20.1 dev eth0 
10.0.0.0/24 dev eth1 proto kernel scope link src 10.0.0.50 
172.20.20.0/24 dev eth0 proto kernel scope link src 172.20.20.2 
```

See how the default is pointing to `172.20.20.1`? That means if you ask it to go somewhere it is going to route out there first. Not good for us! We need to route internally. Also, we want to keep that external pathway out so we can update alpine linux. Eventually we will set up the router to be a real router to the internet. 

Let's remove that default route and change it so we have two default routes with different weightings 

```sh
ip route del default via 172.20.20.1 dev eth0
ip route add default via 10.0.0.1 dev eth1 metric 100
ip route add default via 172.20.20.1 dev eth0 metric 200


ip route show
default via 10.0.0.1 dev eth1 metric 100 
default via 172.20.20.1 dev eth0 metric 200 
10.0.0.0/24 dev eth1 proto kernel scope link src 10.0.0.50 
172.20.20.0/24 dev eth0 proto kernel scope link src 172.20.20.2 
```

```bash
ping -c 4 10.0.0.1
PING 10.0.0.1 (10.0.0.1): 56 data bytes
64 bytes from 10.0.0.1: seq=0 ttl=64 time=0.046 ms
64 bytes from 10.0.0.1: seq=1 ttl=64 time=0.093 ms
64 bytes from 10.0.0.1: seq=2 ttl=64 time=0.095 ms
64 bytes from 10.0.0.1: seq=3 ttl=64 time=0.101 ms

--- 10.0.0.1 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 0.046/0.083/0.101 ms



ping -c 4 10.0.1.1
PING 10.0.1.1 (10.0.1.1): 56 data bytes
64 bytes from 10.0.1.1: seq=0 ttl=64 time=0.037 ms
64 bytes from 10.0.1.1: seq=1 ttl=64 time=0.039 ms
64 bytes from 10.0.1.1: seq=2 ttl=64 time=0.102 ms
64 bytes from 10.0.1.1: seq=3 ttl=64 time=0.099 ms

--- 10.0.1.1 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 0.037/0.069/0.102 ms
```

Looking good we can bing both branches of our network

Exit and go back to the host terminal. 


```bash
sudo containerlab inspect -a

+---+--------------+--------------------+--------------------------------------+--------------+----------------------+-------+---------+----------------+----------------------+
| # |  Topo Path   |      Lab Name      |                 Name                 | Container ID |        Image         | Kind  |  State  |  IPv4 Address  |     IPv6 Address     |
+---+--------------+--------------------+--------------------------------------+--------------+----------------------+-------+---------+----------------+----------------------+
| 1 | topology.yml | test-router-static | clab-test-router-static-r1           | 3f477de258f5 | frrouting/frr:latest | linux | running | 172.20.20.3/24 | 2001:172:20:20::3/64 |
| 2 |              |                    | clab-test-router-static-test         | 77235941d099 | reverse-ctf-server   | linux | running | 172.20.20.2/24 | 2001:172:20:20::2/64 |
| 3 |              |                    | clab-test-router-static-workstation1 | 89f0c8f926ee | alpine:latest        | linux | running | 172.20.20.4/24 | 2001:172:20:20::4/64 |
+---+--------------+--------------------+--------------------------------------+--------------+----------------------+-------+---------+----------------+----------------------+

```

Right, let's hop on workstation1

```sh
apk update
apk add iproute2

ip addr add 10.0.1.50/24 dev eth1 
ip link set eth1 up


ip route del default via  172.20.20.1 dev eth0
ip route add default via 10.0.1.1 dev eth1 metric 100
ip route add default via 172.20.20.1 dev eth0 metric 200


ping -c 4 10.0.1.1
PING 10.0.1.1 (10.0.1.1): 56 data bytes
64 bytes from 10.0.1.1: seq=0 ttl=64 time=0.043 ms
64 bytes from 10.0.1.1: seq=1 ttl=64 time=0.103 ms
64 bytes from 10.0.1.1: seq=2 ttl=64 time=0.036 ms
64 bytes from 10.0.1.1: seq=3 ttl=64 time=0.105 ms

--- 10.0.1.1 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 0.036/0.071/0.105 ms


ping -c 4 10.0.0.1
PING 10.0.0.1 (10.0.0.1): 56 data bytes
64 bytes from 10.0.0.1: seq=0 ttl=64 time=0.041 ms
64 bytes from 10.0.0.1: seq=1 ttl=64 time=0.162 ms
64 bytes from 10.0.0.1: seq=2 ttl=64 time=0.349 ms
64 bytes from 10.0.0.1: seq=3 ttl=64 time=0.347 ms

--- 10.0.0.1 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 0.041/0.224/0.349 ms



ping -c 4 10.0.0.50
PING 10.0.0.50 (10.0.0.50): 56 data bytes
64 bytes from 10.0.0.50: seq=0 ttl=63 time=0.043 ms
64 bytes from 10.0.0.50: seq=1 ttl=63 time=0.110 ms
64 bytes from 10.0.0.50: seq=2 ttl=63 time=0.121 ms
64 bytes from 10.0.0.50: seq=3 ttl=63 time=0.126 ms

--- 10.0.0.50 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 0.043/0.100/0.126 ms
```

Magic!