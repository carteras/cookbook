FROM: alpine:latest 

RUN apk update

RUN apk add busybox-extras termshark libcap bash

RUN adduser -D testuser && \
    echo "testuser:password123" | chpasswd && \
    setcap cap_net_raw, cap_net_admin+eip /usr/bin/dumpcap && \
    addgroup wireshark && \
    adduser testuser wireshark 

CMD ["/bin/bash"]