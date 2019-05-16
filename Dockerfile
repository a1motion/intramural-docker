FROM ubuntu:18.10

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && apt-get install -y -q --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git \
    libssl-dev \
    wget \
    gnupg2


RUN mkdir -p /usr/local/.nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10

WORKDIR $NVM_DIR

RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install 8 \
    && nvm install 10 \
    && nvm install 12 \
    && nvm alias default 10 \
    && nvm use 10

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update
RUN apt-get install --no-install-recommends yarn

RUN groupadd mural
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo,mural -u 1000 mural
USER mural:mural
WORKDIR /home/mural

ENV CI true
ENV NODE_ENV test
