  export POD_IP=`/sbin/ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print \$2}' | tr -d "addr" `
  echo " ############POD_IP     $POD_IP"
  echo  "############ALL_CONF: ${ALL_CONF}"
  java -jar -Xms256m  -Xmx512m  /{{JAR_NAME}}.jar  ${ALL_CONF}