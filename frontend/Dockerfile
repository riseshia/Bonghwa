FROM node:7.10.0
MAINTAINER shia <rise.shia@gmail.com>

RUN mkdir /app
WORKDIR /app

RUN apt-get update && \
    apt-get install -y curl apt-transport-https && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn && \
    rm -rf /var/lib/apt/lists/*

ADD ./package.json /app/
ADD ./yarn.lock /app/

RUN yarn install
