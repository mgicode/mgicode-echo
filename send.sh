ip="192.168.10.20"

scp Dockerfile root@$ip:/root/Dockerfile
scp dist/mgicode-echo-1.0-SNAPSHOT.jar root@$ip:/root/
scp startup.sh  root@$ip:/root/


docker rm mgicode-echo
docker rmi 192.168.0.20:5000/mgicode-echo -f
docker build -t 192.168.0.20:5000/mgicode-echo  /root/  -f Dockerfile
docker push 192.168.0.20:5000/mgicode-echo



docker run -d   --name mgicode-echo1 \
 --env TCP_PORT="8081"  --env SERVER_NAME="mgicode-echo" --env HTTP_PORT="8080" \
 -p 8080:8080 -p 8081:8081  192.168.0.20:5000/mgicode-echo
docker logs mgicode-echo1
