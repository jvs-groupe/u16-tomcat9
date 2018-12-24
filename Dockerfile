# Version 1.0.2

FROM jvsgroupe/u16_core
MAINTAINER Jérôme KLAM, "jerome.klam@jvs.fr"

RUN apt-get install -y build-essential software-properties-common

# Install JDK 8
RUN \
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
add-apt-repository -y ppa:webupd8team/java && \
apt-get update && \
apt-get install -y oracle-java8-installer wget unzip tar && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Tomcat
WORKDIR /opt
RUN wget http://apache.mirrors.ovh.net/ftp.apache.org/dist/tomcat/tomcat-9/v9.0.14/bin/apache-tomcat-9.0.14.tar.gz
RUN tar xzf apache-tomcat-9.0.14.tar.gz
RUN mv apache-tomcat-9.0.14 apache-tomcat9
RUN rm -f apache-tomcat-9.0.14.tar.gz
WORKDIR /opt/apache-tomcat9
RUN chmod -R +rX .
RUN chmod 777 logs work
# Tomcat Config
ENV CATALINA_HOME="/opt/apache-tomcat9"
ENV TOMCAT_HOME="/opt/apache-tomcat9"
# Users
COPY docker/tomcat-users.xml /opt/apache-tomcat9/conf/
COPY docker/host-manager.xml /opt/apache-tomcat9/webapps/host-manager/META-INF/context.xml 
COPY docker/manager.xml /opt/apache-tomcat9/webapps/manager/META-INF/context.xml 

# Outils
RUN apt-get update && apt-get install -y maven
RUN mkdir -p /opt/java
RUN mkdir -p /root/.m2
RUN mkdir -p /root/.m2/repository/

# startup
ENV PATH $PATH:$CATALINA_HOME/bin
RUN chmod +x /opt/apache-tomcat9/bin/startup.sh

# Ports
EXPOSE 8080

# Volumes
VOLUME /opt/apache-tomcat9/webapps
VOLUME /opt/java
VOLUME /root/.m2/repository/

# End
CMD ["catalina.sh", "run"]