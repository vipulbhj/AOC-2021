FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \ 
      build-essential \
      git \
      curl \
      ghc \
      openjdk-8-jdk \
      nodejs \
      smlnj

RUN curl -fsSL https://deb.nodesource.com/setup_17.x | sh -

RUN curl https://nim-lang.org/choosenim/init.sh -sSf | bash -s -- -y
ENV PATH=/root/.nimble/bin:$PATH

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="${HOME}/.cargo/bin:${PATH}"

WORKDIR /home
