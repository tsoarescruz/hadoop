FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive
MAINTAINER Everton Gago <everton.gago@dextra-sw.com>

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get -y update
RUN echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
RUN apt-get -y install oracle-java8-installer

RUN apt-get -y install vim
RUN apt-get -y install unzip

RUN wget -P /opt http://ftp.unicamp.br/pub/apache/hadoop/common/hadoop-3.1.0/hadoop-3.1.0.tar.gz
RUN wget -P /opt http://ftp.unicamp.br/pub/apache/mahout/0.13.0/apache-mahout-distribution-0.13.0.tar.gz
RUN wget -P /root http://www.grouplens.org/system/files/ml-100k.zip

RUN tar xvfz /opt/hadoop-3.1.0.tar.gz -C /opt
RUN tar xvfz /opt/apache-mahout-distribution-0.13.0.tar.gz -C /opt
RUN unzip /root/ml-100k.zip -d /root
RUN rm /opt/hadoop-3.1.0.tar.gz
RUN rm /opt/apache-mahout-distribution-0.13.0.tar.gz
RUN rm /root/ml-100k.zip

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /opt/hadoop-3.1.0/etc/hadoop-env.sh

RUN echo "<?xml version=\"1.0\"?>" > /opt/hadoop-3.1.0/etc/hadoop/core-site.xml && \
    echo "<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>" >> /opt/hadoop-3.1.0/etc/hadoop/core-site.xml && \
    echo "<configuration>" >> /opt/hadoop-3.1.0/etc/hadoop/core-site.xml && \
    echo "  <property>" >> /opt/hadoop-3.1.0/etc/hadoop/core-site.xml && \
    echo "    <name>fs.default.name</name>" >> /opt/hadoop-3.1.0/etc/hadoop/core-site.xml && \
    echo "    <value>hdfs://localhost:9000</value>" >> /opt/hadoop-3.1.0/etc/hadoop/core-site.xml && \
    echo "  </property>" >> /opt/hadoop-3.1.0/etc/hadoop/core-site.xml && \
    echo "</configuration>" >> /opt/hadoop-3.1.0/etc/hadoop/core-site.xml

RUN echo "export JAVA_HOME=\"/usr/lib/jvm/java-7-oracle\"" >> /root/.bashrc && \
    echo "export HADOOP_PREFIX=\"/opt/hadoop-1.2.1\"" >> /root/.bashrc && \
    echo "export HADOOP_CONF_DIR=\"/opt/hadoop-1.2.1/conf\"" >> /root/.bashrc && \
    echo "export PATH=\"/opt/hadoop-1.2.1/bin:$PATH\"" >> /root/.bashrc

RUN mkdir /root/.ssh
RUN ssh-keygen -t rsa -P '' -f /root/.ssh/id_rsa
RUN cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys
