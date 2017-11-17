#!/usr/bin/env bash

scp Dockerfile root@202.121.178.167:/Dockerfile

docker build -t 192.168.0.20:5000/mgicode-echo  /root/  -f Dockerfile


##TCP_PORT  SERVER_NAME  HTTP_PORT

docker run -d    --name mgicode-echo \
 --env TCP_PORT="8081"  --env SERVER_NAME="mgicode-echo" --env HTTP_PORT="8080" \
 -p 8080:8080 -p 8081:8081  192.168.0.20:5000/mgicode-echo