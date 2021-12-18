FROM ubuntu:18.04
 
RUN apt-get update && apt-get upgrade -y && apt-get install -y curl
RUN apt-get install build-essential -y
 
WORKDIR /home 
 
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="${HOME}/.cargo/bin:${PATH}"
