FROM debian:bookworm

RUN apt-get update -qq \
    && apt-get install -y cowsay fortune \
    && apt-get install -y curl apt-file iproute2 iputils-ping iputils-tracepath \
    && apt-get install -y tar \
    && apt-file update \
    ;

WORKDIR /
