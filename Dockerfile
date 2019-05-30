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
    gnupg2 \
    sudo

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN groupadd mural
RUN useradd -rm -d /home/mural -s /bin/bash -g mural -G mural -u 1000 mural
RUN adduser mural sudo

ENV NVM_DIR /home/mural/.nvm
ENV NODE_VERSION 10

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update
RUN apt-get install --no-install-recommends yarn

USER mural:mural
WORKDIR /home/mural

RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install 8 \
    && nvm install 10 \
    && nvm install 12 \
    && nvm alias default 10 \
    && nvm use 10

ENV CI true
ENV NODE_ENV test
