#!/bin/bash
# 编译部署脚本

# 获取当前目录
BASE_DIR=$(pwd)

# 编译
cd $BASE_DIR/initializr && mvn install -DskipTests=true
cd $BASE_DIR/initializr-service && spring jar start.jar app.groovy


cd $BASE_DIR

CONTAINER=start

RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER 2> /dev/null)

# 停掉老版本
if [ $? -eq 1 ]; then
  echo "UNKNOWN - $CONTAINER does not exist."
else
  docker -H 172.27.2.136:3376 rm -f start
fi

# 构建image
docker -H 172.27.2.136:3376 build -t initializr .

# 运行
docker -H 172.27.2.136:3376 run -d --name start -p 8088:8080 initializr
