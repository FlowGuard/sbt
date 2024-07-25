#
# Scala and sbt Dockerfile
#
# https://github.com/hseeberger/scala-sbt
#

# Pull base image
FROM debian:buster-slim

ARG version=11.0.24.8-1
# pulling fresh image and setting it uo the same way as the amazoncorretto 11.0.24-deb image
# (pre-created images are mostly alipnes)

# Env variables
ENV LANG C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto
ENV SCALA_VERSION 2.13.0
ENV SBT_VERSION 1.3.1
ENV NODE_VERSION 12.15.0

RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        curl ca-certificates gnupg software-properties-common fontconfig java-common unzip xz-utils \
    && curl -fL https://apt.corretto.aws/corretto.key | apt-key add - \
    && add-apt-repository 'deb https://apt.corretto.aws stable main' \
    && mkdir -p /usr/share/man/man1 || true \
    && apt-get update \
    && apt-get install -y java-11-amazon-corretto-jdk=1:$version


## Scala expects this file
#RUN mkdir -p /usr/lib/jvm/ && \
#    ln -s /usr/local/openjdk-17/ /usr/lib/jvm/java-17-openjdk-amd64 && \
#    touch /usr/lib/jvm/java-17-openjdk-amd64/release

# Install Scala
RUN \
    curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /opt/ && \
    echo >> /root/.bashrc && \
    echo "export PATH=/opt/scala-$SCALA_VERSION/bin:\$PATH" >> /root/.bashrc

## Instal nodejs
RUN \
    curl -fsL https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz | tar xJf - -C /opt/ && \
    echo "export PATH=/opt/node-v$NODE_VERSION-linux-x64/bin:\$PATH" >> /root/.bashrc

RUN mkdir -p /sbt

WORKDIR /sbt

# Install sbt
RUN \
    curl -L -O https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.zip && \
    unzip -q sbt-${SBT_VERSION}.zip -d /opt && \
    rm sbt-${SBT_VERSION}.zip && \
    echo "export PATH=/opt/sbt/bin/:\$PATH" >> /root/.bashrc && \
    . /root/.bashrc; sbt sbtVersion && \
    ln -s /opt/sbt/bin/sbt /usr/bin/sbt \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        curl gnupg software-properties-common

# Create workdir
RUN mkdir -p /jenkins/workspace

# Define working directory
WORKDIR /jenkins/workspace
