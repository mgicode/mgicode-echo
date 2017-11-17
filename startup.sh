 #!/bin/bash
      set +e
       #注意=前后不能有空格 #xargs,
       export POD_IP=`/sbin/ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print \$2}' | tr -d "addr" `
       echo " ############POD_IP     $POD_IP"
      mkdir -p /microservice/
      cd /microservice/
      wget $JAR_ADDR
      chmod 777 {{JAR_NAME}}
      # hostnetwork中使用 --server.address=$POD_IP 网络访问不了
      # --spring.profiles.active 用来读取不同的配置文件
      java -jar -Xms256m  -Xmx512m  {{JAR_NAME}}   --server.port={{HTTP_PORT}}  --thrift.server.port={{THRIFT_PORT}}  --spring.profiles.active=test
