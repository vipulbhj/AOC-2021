FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \ 
      build-essential \
      curl \
      ghc \
      openjdk-8-jdk

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="${HOME}/.cargo/bin:${PATH}"

WORKDIR /home
