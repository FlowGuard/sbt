#
# Scala and sbt Dockerfile
#
# https://github.com/hseeberger/scala-sbt
#

# Pull base image
FROM openjdk:8u181

# Env variables
ENV SCALA_VERSION 2.11.12
ENV SBT_VERSION 1.5.0

# Scala expects this file
RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

# Install Scala
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /opt/ && \
  echo >> /root/.bashrc && \
  echo "export PATH=/opt/scala-$SCALA_VERSION/bin:\$PATH" >> /root/.bashrc

WORKDIR /root

# Install sbt
RUN \
  curl -L -O https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.zip && \
  unzip -q sbt-${SBT_VERSION}.zip -d /opt && \
  rm sbt-${SBT_VERSION}.zip && \
  echo "export PATH=/opt/sbt/bin/:\$PATH" >> /root/.bashrc && \
  . /root/.bashrc; sbt sbtVersion && \
  ln -s /opt/sbt/bin/sbt /usr/bin/sbt

# Create workdir
RUN mkdir -p /jenkins/workspace

# Define working directory
WORKDIR /jenkins/workspace
