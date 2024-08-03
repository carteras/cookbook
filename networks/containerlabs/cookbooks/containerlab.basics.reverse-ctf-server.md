# How to deploy the reverse CTF test machine for networking and security

To allow for testing of your network, you must deploy a test machine on your network and expose your ports on our internal network.

## Create a topology file

```yaml
name: reverse_ctf_tester
topology:
  nodes:
    alpine:
      kind: linux
      image: reverse-ctf-server
      ports:
        - "2222:22/tcp"
```
