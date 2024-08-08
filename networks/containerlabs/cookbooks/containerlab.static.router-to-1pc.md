# Set router with single static network





## Create a topology file



```yaml
name: test-1-router-1work-static
topology:
  nodes:
    r1:
      kind: linux
      image: frrouting/frr:latest

    alpine_workstation:
        kind:linux
        image: alpine:latest
    test:
      kind: linux
      image: reverse-ctf-server
      ports:
        - "2222:22/tcp"
  links: 
    - endpoints: ['r1:eth1', 'test:eth1']
    - endpoints: ['r1:eth2', 'alpine_workstation:eth1']
```

## Configuration