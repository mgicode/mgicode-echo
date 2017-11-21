#!/usr/bin/env bash

msIP=192.168.0.8
jarName=mgicode-echo-1.1-SNAPSHOT
dockerImageAddr=192.168.0.20:5000

msName=ms01
HTTP_PORT=8080
TCP_PORT=8081


startupFileName=startup.sh
execFileName=docker.sh
dockerTemplateFileName=DockerfileTmplate

#新生成dockerfile文件，并替换生成Dockerfile模板
cp dockerTemplateFileName  Dockerfile
sed  -i  "s/{{JAR_NAME}}/$jarName/g;" Dockerfile
cat Dockerfile
sleep 5

#构建docker images 并上传到docker register
docker build -t ${dockerImageAddr}/${jarName}  /root/${jarName}/  -f Dockerfile
docker push ${dockerImageAddr}/${jarName}

#t重新运行，需要生成CONSUL_KEY_TOKEN
execScript="
docker stop  ${jarName} ;
docker rm ${jarName} ;
#一定要清除原有镜像，不然不会拉
docker rmi ${dockerImageAddr}/${jarName} ;
docker run -d   --name ${jarName}  --restart=always  \
 --env ALL_CONF=\"
    --spring.application.name=${msName}  \
    --server.port=${HTTP_PORT}  \
    --tcp.port=${TCP_PORT}  \
    --endpoints.health.sensitive=false \
    --management.security.enabled=false \
    --management.health.consul.enabled=false \
   --spring.cloud.consul.discovery.enabled=true  \
   --spring.cloud.consul.host=192.168.0.17 \
   --spring.cloud.consul.port=8500      \
   --spring.cloud.consul.discovery.healthCheckUrl=\\${management.contextPath}/health
  \" \
 -p ${HTTP_PORT}:${HTTP_PORT} -p ${TCP_PORT}:${TCP_PORT}  ${dockerImageAddr}/${jarName}
  "

sleep 10
docker logs ${jarName}


#for ip in $NODE_IPS ;do

      ssh root@$msIP "$execScript"
      sleep 5

#done


curl http://${msIP}:${HTTP_PORT}/health



