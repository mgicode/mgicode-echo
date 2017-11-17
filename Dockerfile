FROM registry.cn-hangzhou.aliyuncs.com/prk/centos7_jdk1.8

WORKDIR  /
RUN wget  https://github.com/mgicode/mgicode-echo/blob/master/dist/mgicode-echo-1.0-SNAPSHOT.jar
RUN wget  https://github.com/mgicode/mgicode-echo/blob/master/startup.sh

RUN chmod +x /startup.sh
RUN chmod +x mgicode-echo-1.0-SNAPSHOT.jar

ENTRYPOINT /startup.sh
