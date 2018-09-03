# use the ubuntu base image provided by dotCloud
FROM ubuntu:14.04

# copy config file for mysql
ADD configs/my.cnf /etc/mysql/my.cnf

# make sure the package repository is up to date
RUN apt-get update

# install apache2
RUN apt-get -y install apache2

# install php
RUN apt-get -y install php5
RUN apt-get -y install libapache2-mod-php5

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start
RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

# install mysql
RUN apt-get install -y -o Dpkg::Options::="--force-confold" mysql-common
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y mysql-server
RUN apt-get install -y libapache2-mod-auth-mysql php5-mysql --force-yes

# apache2 configuration
ADD scripts/apache2_conf.sh /home/scripts/apache2_conf.sh
RUN chmod +x /home/scripts/apache2_conf.sh
RUN /home/scripts/apache2_conf.sh

# environment value
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2

# install ssh for maintainance
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN echo root:password | chpasswd
RUN echo 'rootpass ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# install requirements for phpbrew
RUN apt-get install -y php5 php5-dev php-pear autoconf automake curl build-essential libxslt1-dev re2c libxml2 libxml2-dev php5-cli bison libbz2-dev libreadline-dev
RUN apt-get install -y libfreetype6 libfreetype6-dev libpng12-0 libpng12-dev libjpeg-dev libjpeg8-dev libjpeg8  libgd-dev libgd3 libxpm4 libltdl7 libltdl-dev
RUN apt-get install -y gettext libgettextpo-dev libgettextpo0
RUN apt-get install -y php5-cli libicu-dev libmcrypt-dev libcurl4-openssl-dev apache2-dev
RUN apt-get install -y libssl-dev openssl

# install phpbrew
RUN curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
RUN chmod +x phpbrew
RUN mv phpbrew /usr/bin/phpbrew

# switch php version
RUN phpbrew init
RUN phpbrew known --update
RUN phpbrew update
RUN phpbrew -d install 5.4.45 +default+mysql+pdo+debug+apxs2

# install editor tool
RUN apt-get -y install nano

# expose ports
EXPOSE 8080
EXPOSE 3306
EXPOSE 22

VOLUME /root
WORKDIR /root

# entrypoint
COPY scripts/startup.sh /home/scripts/startup.sh
ENTRYPOINT bash /home/scripts/startup.sh & /bin/bash
