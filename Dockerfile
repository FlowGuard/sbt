#
# Scala and sbt Dockerfile
#
# https://github.com/hseeberger/scala-sbt
#

# Pull base image
FROM openjdk:11-jdk-slim

# Env variables
ENV SCALA_VERSION 2.12.10
ENV SBT_VERSION 1.3.8
ENV NODE_VERSION 12.15.0

# Add curl
RUN apt update && \
    apt install curl xz-utils unzip --no-install-recommends -y && \
    rm -rf /var/lib/apt/lists/*

# Scala expects this file
RUN mkdir -p /usr/lib/jvm/ && \
    ln -s /usr/local/openjdk-11/ /usr/lib/jvm/java-11-openjdk-amd64 && \
    touch /usr/lib/jvm/java-11-openjdk-amd64/release

# Install Scala
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /opt/ && \
  echo >> /root/.bashrc && \
  echo "export PATH=/opt/scala-$SCALA_VERSION/bin:\$PATH" >> /root/.bashrc

# Instal nodejs
RUN \
  curl -fsL https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz | tar xJf - -C /opt && \
  echo "export PATH=/opt/node-v$NODE_VERSION-linux-x64/bin:\$PATH" >> /root/.bashrc

# Install sbt
RUN \
  curl -L -O https://piccolo.link/sbt-${SBT_VERSION}.zip && \
  unzip -q sbt-${SBT_VERSION}.zip -d /opt && \
  rm sbt-${SBT_VERSION}.zip && \
  echo "export PATH=/opt/sbt/bin/:\$PATH" >> /root/.bashrc && \
  . /root/.bashrc; sbt sbtVersion && \
  ln -s /opt/sbt/bin/sbt /usr/bin/sbt

# Create workdir
RUN mkdir -p /jenkins/workspace

# Define working directory
WORKDIR /jenkins/workspace
