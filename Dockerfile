# Dockerfile
FROM node:slim
MAINTAINER fakeYanss <yanshisangc@gmail.com>

RUN apt-get update && apt-get install -y git ssh-client ca-certificates --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN echo "Asia/Shanghai" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN npm install -g cnpm --registry=https://registry.npm.taobao.org
RUN cnpm install hexo-cli -g
RUN cnpm install hexo-server

EXPOSE 4000
