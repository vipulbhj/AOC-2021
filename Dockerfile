FROM ubuntu:18.04

RUN apt clean && apt-get clean

RUN export DEBIAN_FRONTEND=noninteractive 
RUN ln -fs /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \ 
      build-essential \
      software-properties-common \
      git \
      wget \
      curl \
      rlwrap \
      ghc \
      openjdk-8-jdk \
      smlnj \
      perl \
      libdata-dump-perl \
      php \
      ruby-full

# DLang installation step.
RUN curl https://dlang.org/install.sh | bash -s

# Node installation steps.
RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash -s -- -y
RUN apt-get install -y nodejs

# NIM installation steps.
RUN curl https://nim-lang.org/choosenim/init.sh -sSf | bash -s -- -y
ENV PATH=/root/.nimble/bin:$PATH

# Rust installation steps
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="${HOME}/.cargo/bin:${PATH}"

# Erlang Installation steps
RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && \
    dpkg -i erlang-solutions_2.0_all.deb && \
    apt-get update -y && apt-get install -y esl-erlang elixir && \
    rm erlang-solutions_2.0_all.deb

# Mono C# and F# Installation steps
RUN apt install gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y mono-complete fsharp

# Scala Installation Steps
RUN curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > cs && \
    chmod +x cs && \
    ./cs install cs && \
    ./cs install scala3-compiler && \
    ./cs install scala3 && rm ./cs
ENV PATH="$PATH:/root/.local/share/coursier/bin"

# Kotlin Installation Steps.
RUN curl -s https://get.sdkman.io | bash
RUN ["/bin/bash", "-c", "source $HOME/.sdkman/bin/sdkman-init.sh; sdk install kotlin"]

# Installing Clojure
RUN curl https://download.clojure.org/install/linux-install-1.10.3.1058.sh | bash 

# Installing Dart
RUN apt-get update && \
    apt-get install apt-transport-https && \
    sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list' && \
    apt-get update && \
    apt-get install dart



WORKDIR /home
