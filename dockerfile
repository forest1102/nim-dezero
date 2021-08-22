FROM debian:stable-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata
ENV TZ=Asia/Tokyo
RUN apt-get install -y \
  vim \
  curl \
  gcc \
  git \
  gdb \
  libblas-dev liblapack-dev

RUN curl https://nim-lang.org/choosenim/init.sh -sSf | sh -s -- -y
ENV PATH="/root/.nimble/bin:$PATH"

WORKDIR /workspace
ADD /nim_dezero.nimble /workspace
RUN nimble develop -y
