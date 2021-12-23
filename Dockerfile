FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \ 
      build-essential \
      git \
      wget \
      curl \
      ghc \
      openjdk-8-jdk \
      nodejs \
      smlnj \
      perl \
      libdata-dump-perl

RUN curl https://dlang.org/install.sh | bash -s

RUN curl -fsSL https://deb.nodesource.com/setup_17.x | sh -

RUN curl https://nim-lang.org/choosenim/init.sh -sSf | bash -s -- -y
ENV PATH=/root/.nimble/bin:$PATH

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="${HOME}/.cargo/bin:${PATH}"

RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && \
    dpkg -i erlang-solutions_2.0_all.deb && \
    apt-get update -y && apt-get install -y esl-erlang elixir

WORKDIR /home
