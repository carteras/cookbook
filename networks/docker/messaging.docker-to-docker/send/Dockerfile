# ContainerA Dockerfile
FROM alpine:latest

# Install netcat
RUN apk add --no-cache netcat-openbsd

# Set up an entrypoint to send a message every 5 seconds
ENTRYPOINT ["sh", "-c", "while true; do echo 'Hello from ContainerA' | nc -w 1 $CONTAINERB_IP 12345; sleep 5; done"]
