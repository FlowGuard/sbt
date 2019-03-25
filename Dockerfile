#
# Scala and sbt Dockerfile
#
# https://github.com/hseeberger/scala-sbt
#

# Pull base image
FROM openjdk:11

# Env variables
ENV SCALA_VERSION 2.12.8
ENV SBT_VERSION 1.2.8

# Scala expects this file
RUN touch /usr/lib/jvm/java-11-openjdk-amd64/release

# Install Scala
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /opt/ && \
  echo >> /root/.bashrc && \
  echo "export PATH=/opt/scala-$SCALA_VERSION/bin:\$PATH" >> /root/.bashrc

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
