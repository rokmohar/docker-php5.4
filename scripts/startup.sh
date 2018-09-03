#!/bin/bash

# change php version
export PHPBREW_SET_PROMPT=1
source /root/.phpbrew/bashrc
phpbrew switch php-5.4.45

# change apache php module
echo "LoadModule php5_module /usr/lib/apache2/modules/libphp5.4.45.so" > /etc/apache2/mods-available/php5.load

# Start ssh
/etc/init.d/ssh start

# Start apache
/etc/init.d/apache2 start

# Start mysql
/etc/init.d/mysql start

echo "grant all privileges on *.* to 'root'@'%'; flush privileges;" | mysql -uroot -proot
echo "update mysql.user set password=PASSWORD('root') where user='root'; flush privileges;" | mysql -uroot -proot

exec "$@"
