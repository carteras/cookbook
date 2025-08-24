docker build --no-cache -t docker.alpine.netcat.send.spam -f Dockerfile .

docker run --network host -e CONTAINERB_IP=10.13.37.50 docker.alpine.netcat.send.spam

