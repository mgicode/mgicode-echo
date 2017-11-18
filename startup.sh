  export POD_IP=`/sbin/ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print \$2}' | tr -d "addr" `
  echo " ############POD_IP     $POD_IP"
   serverPort=""
   if [ $HTTP_PORT ]; then
    serverPort=" --server.port=${HTTP_PORT}"
   else
    serverPort=""
   fi

   tcpPort=""
   if [ $TCP_PORT ]; then
    tcpPort=" --tcp.port=${TCP_PORT}"
   else
    tcpPort=""
   fi

   serverName=""
   if [ $SERVER_NAME ]; then
    serverName=" --server.name=${SERVER_NAME}"
   else
    serverName=""
   fi

 echo  "TCP_PORT:${TCP_PORT},SERVER_NAME:${SERVER_NAME},HTTP_PORT:${HTTP_PORT}"

  java -jar -Xms256m  -Xmx512m  /mgicode-echo-1.0-SNAPSHOT.jar  ${serverName}  ${serverPort}   ${tcpPort}