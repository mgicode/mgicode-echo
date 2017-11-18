FROM registry.cn-hangzhou.aliyuncs.com/prk/centos7_jdk1.8

WORKDIR  /
#RUN wget  https://github.com/mgicode/mgicode-echo/blob/master/dist/mgicode-echo-1.0-SNAPSHOT.jar
#RUN wget  https://github.com/mgicode/mgicode-echo/blob/master/startup.sh
ADD startup.sh  /startup.sh
ADD mgicode-echo-1.1-SNAPSHOT.jar  /mgicode-echo-1.1-SNAPSHOT.jar

RUN chmod +x /startup.sh
RUN chmod +x /mgicode-echo-1.1-SNAPSHOT.jar

ENTRYPOINT /startup.sh
