# mgicode-echo
找了好久都没有找到回声的docker进行测试用，自己写了一个

**编译的Docker镜像**

1、v1.0 ，不带consul
docker pull registry.cn-hangzhou.aliyuncs.com/prk/mgicode-echo

2、带v1.1 带consul
docker pull registry.cn-hangzhou.aliyuncs.com/prk/mgicode-echo:1.1

**自己编译**

1、git下载源码
  git@github.com:mgicode/mgicode-echo.git

2、采用spring boot打包成jar或采用dist/下面的jar

3、找一台docker环境，编译deploy/Dockerfile即可