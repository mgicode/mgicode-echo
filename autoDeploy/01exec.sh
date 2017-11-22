#!/usr/bin/env bash
#修改这两个文件
adminIp=202.121.178.167
jarName=mgicode-echo-1.2-SNAPSHOT
#/Users/prk/Projects/jxgs/mgicode-echo/target/mgicode-echo-1.2-SNAPSHOT.jar
jarPath="/Users/prk/Projects/jxgs/mgicode-echo/target/";
startupFileName=startup.sh
execFileName=docker.sh


toPath=/root/${jarName}/
ssh root@$adminIp "rm -rf  $toPath ; mkdir -p $toPath"

#复制模板和执行文件
scp $execFileName  root@$adminIp:${toPath}${execFileName}
scp $startupFileName  root@$adminIp:${toPath}Template${startupFileName}
scp Dockerfile  root@$adminIp:${toPath}TemplateDockerfile

scp ${jarPath}${jarName}.jar  root@$adminIp:${toPath}${jarName}.jar

#scp ../dist/${jarName}.jar  root@$adminIp:${toPath}${jarName}.jar

#执行命令文件
echo  $toPath
ssh root@$adminIp "cd ${toPath}; chmod 777 ${execFileName} ; ls ${toPath}; ./${execFileName}   "
#ssh root@$adminIp "cd ${toPath}; chmod 777 ${execFileName} ; ${toPath}${execFileName} ;ls ${toPath}  "
