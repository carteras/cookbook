# ContainerA Dockerfile
FROM alpine:latest

# Install netcat
RUN apk add --no-cache netcat-openbsd

# Set up an entrypoint to send a message every 5 seconds
ENTRYPOINT ["sh", "-c", "while true; do echo 'Hello from ContainerA' | nc -u -w 1 10.13.37.50 12345; sleep 5; done"]

