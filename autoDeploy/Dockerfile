FROM registry.cn-hangzhou.aliyuncs.com/prk/centos7_jdk1.8

WORKDIR  /

ADD startup.sh  /startup.sh
ADD {{JAR_NAME}}.jar  /{{JAR_NAME}}.jar

RUN chmod +x /startup.sh
RUN chmod +x /{{JAR_NAME}}.jar

ENTRYPOINT /startup.sh
