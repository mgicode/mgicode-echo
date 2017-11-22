#!/usr/bin/env bash

jarName=mgicode-echo-1.2-SNAPSHOT
dockerName=mgicode-echo
dockerVersion="1.2"

msIPS="192.168.0.8  192.168.0.6"
msNames="ms01  gateway01 "
HTTP_PORT="8080 8080 "
TCP_PORT="8081 8081 "
consulIP="192.168.0.17"
consulPort="8500"
dockerAddr="192.168.0.20:5000"

toPath=/root/${jarName}/
dockerPath="${dockerAddr}/${dockerName}:${dockerVersion}"
startupFileName=startup.sh

#新生成startup.js
cp Template${startupFileName}  ${startupFileName}
echo " ${startupFileName}"
sed  -i  "s/{{JAR_NAME}}/$jarName/g;" ${startupFileName}
echo "gen ${startupFileName}..."
cat ${startupFileName}
sleep 5


#新生成dockerfile文件，并替换生成Dockerfile模板
cp TemplateDockerfile  Dockerfile
sed  -i  "s/{{JAR_NAME}}/$jarName/g;" Dockerfile
echo "gen Dockerfile..."
cat Dockerfile
sleep 5


echo "构建docker images 并上传到docker register..."
#构建docker images 并上传到docker register
echo "dockerPath:${dockerPath},toPath:${toPath}"

docker rmi ${dockerPath}
docker build -t ${dockerPath}  $toPath  -f Dockerfile
docker push ${dockerPath}
#docker build -t 192.168.0.20:5000/mgicode-echo  /root/1.1/  -f Dockerfile

sleep 10


i=0
NAMES=(${msNames})
HTTPPORTS=(${HTTP_PORT})
TCPPORTS=(${TCP_PORT})

for ip in $msIPS ;do
  echo "exec ${ip} ..."
  MSNAME=${NAMES[$i]}
  HTTPPORT=${HTTPPORTS[$i]}
  TCPPORT=${TCPPORTS[$i]}

 echo "MSNAME:${MSNAME}, HTTPPORT:${HTTPPORT},TCPPORT:${TCPPORT}..."
 execScript="
  docker stop  ${MSNAME} ;
  docker rm ${MSNAME} ;
  #一定要清除原有镜像，不然不会拉
  docker rmi  -f ${dockerPath} ;
  docker run -d   --name ${MSNAME}  --restart=always  \
  --env ALL_CONF=\"
    --spring.application.name=${MSNAME}  \
    --server.port=${HTTPPORT}  \
    --tcp.port=${TCPPORT}  \
    --endpoints.health.sensitive=false \
    --management.security.enabled=false \
    --management.health.consul.enabled=false \
   --spring.cloud.consul.discovery.enabled=true  \
   --spring.cloud.consul.discovery.hostname=${ip}  \
   --spring.cloud.consul.discovery.port=${HTTPPORT} \
   --spring.cloud.consul.discovery.serviceName=${MSNAME} \
   --spring.cloud.consul.host=${consulIP}   \
   --spring.cloud.consul.port=${consulPort}    \

   --spring.cloud.consul.discovery.healthCheckUrl=http://${ip}:${HTTPPORT}/health \
   \"  -p ${HTTPPORT}:${HTTPPORT} -p ${TCPPORT}:${TCPPORT}  ${dockerPath}

   sleep 10
   docker logs ${MSNAME}

   "
  echo "${execScript}"
  sleep 5
  ssh root@$ip "${execScript}"
  sleep 5
  let i++
done

#  --server.address=${ip}  \
  #一定需要
  #--spring.cloud.consul.discovery.serviceName=${MSNAME} \

#http://202.121.178.167:8080

 #docker logs ${MSNAME}
#curl http://${msIP}:${HTTP_PORT}/health



