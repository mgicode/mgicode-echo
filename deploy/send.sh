ip="192.168.0.20"

#1copy file to service
ssh root@$ip "mkdir -p /root/1.1/"
scp Dockerfile root@$ip:/root/1.1/Dockerfile
scp ../dist/mgicode-echo-1.1-SNAPSHOT.jar root@$ip:/root/1.1/
scp startup.sh  root@$ip:/root/1.1/

#2build
cd /root/1.1/
docker rm mgicode-echo
docker rmi 192.168.0.20:5000/mgicode-echo -f
docker build -t 192.168.0.20:5000/mgicode-echo  /root/1.1/  -f Dockerfile

#3push to aliyun and local
docker push 192.168.0.20:5000/mgicode-echo
docker login --username=hi31016710@aliyun.com registry.cn-hangzhou.aliyuncs.com
docker tag  192.168.0.20:5000/mgicode-echo  registry.cn-hangzhou.aliyuncs.com/prk/mgicode-echo:1.1
docker push registry.cn-hangzhou.aliyuncs.com/prk/mgicode-echo:1.1

# 4deploy with docker
docker stop mgicode-echo2
docker rm  mgicode-echo2
docker run -d   --name mgicode-echo2 \
 --env ALL_CONF="--spring.application.name=mgicode-echo  --server.port=8080  --tcp.port=8081 \
   --spring.cloud.consul.discovery.enabled=true  \
 --spring.cloud.consul.host=192.168.0.17 --spring.cloud.consul.port=8500  spring.cloud.consul.discovery.tags=foo=bar,baz "  \
 -p 8080:8080 -p 8081:8081  192.168.0.20:5000/mgicode-echo
docker logs mgicode-echo2

#5 test
sleep 15
curl 127.0.0.1:8080/
curl 127.0.0.1:8080/consul/mgicode-echo
telnet  127.0.0.1 8081
