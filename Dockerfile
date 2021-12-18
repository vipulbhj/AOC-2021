FROM ubuntu:18.04

RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh | sh

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \ 
      build-essential \
      curl \
      ghc \
      openjdk-8-jdk \
      nodejs

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="${HOME}/.cargo/bin:${PATH}"

WORKDIR /home
