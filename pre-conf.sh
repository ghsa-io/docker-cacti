#!/bin/bash

/usr/bin/mysqld_safe &
 
 mysqladmin -u root password mysqlpsswd
 mysqladmin -u root -pmysqlpsswd reload
 mysqladmin -u root -pmysqlpsswd create cacti
 mysql -u root -pmysqlpsswd cacti < /opt/cacti/cacti.sql
 
 mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -pmysqlpsswd mysql

 echo "GRANT ALL ON cacti.* TO cacti@localhost IDENTIFIED BY '9PIu8AbWQSf8'; flush privileges; " | mysql -u root -pmysqlpsswd 
 echo "GRANT SELECT ON mysql.time_zone_name TO cacti@localhost IDENTIFIED BY '9PIu8AbWQSf8'; flush privileges; " | mysql -u root -pmysqlpsswd 

 rm -R /var/www/html
 
 #Needed for setup
 chown -R www-data:www-data /opt/cacti/resource/snmp_queries
 chown -R www-data:www-data /opt/cacti/resource/script_server
 chown -R www-data:www-data /opt/cacti/resource/script_queries
 chown -R www-data:www-data /opt/cacti/scripts
 
 #Needed always
 chown -R www-data:www-data /opt/cacti/rra/ /opt/cacti/log/
 chown -R www-data:www-data /opt/cacti/cache/mibcache
 chown -R www-data:www-data /opt/cacti/cache/realtime
 chown -R www-data:www-data /opt/cacti/cache/spikekill
 
 #to fix error relate to ip address of container apache2
 echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
 ln -s /etc/apache2/conf-available/fqdn.conf /etc/apache2/conf-enabled/fqdn.conf
 
 # to set correct webroot for cacti (inplace edit of default apache2 site conf)
 perl -pi -e's@/var/www/html@/opt/cacti@g' /etc/apache2/sites-enabled/000-default.conf

killall mysqld
sleep 10s
