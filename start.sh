#!/bin/bash
# 编译部署脚本

# 获取当前目录
BASE_DIR=$(pwd)

# 编译
cd $BASE_DIR/initializr && mvn install -DskipTests=true
cd $BASE_DIR/initializr-service && spring jar start.jar app.groovy

# 停掉老版本
docker -H 172.27.2.136:3376 rm -f start

# 构建image
docker -H 172.27.2.136:3376 build -t initializr initializr

# 运行
docker -H 172.27.2.136:3376 run -d --name start -p 8088:8080 initializr
