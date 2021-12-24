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

RUN apt install gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y mono-complete

WORKDIR /home
