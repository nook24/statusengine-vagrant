#!/bin/bash
set -e

#Install 1.5.1 release
wget https://github.com/nook24/statusengine/archive/1.5.1.tar.gz --no-verbose
tar xfv 1.5.1.tar.gz
cd statusengine-1.5.1/

#Install master branch
#wget https://github.com/nook24/statusengine/archive/master.zip --no-verbose
#unzip master.zip
#cd statusengine-master/

#Install Statusengine database cleanup cronjob
cp etc/cron.d/statusengine /etc/cron.d/statusengine

#Install statusengine event broker
mkdir -p /opt/statusengine

#Install statusengine broker configuration file
cp etc/statusengine.json /opt/statusengine/statusengine.json

#Install statusengine event broker
mkdir -p /var/lib/pnp4nagios/perfdata/
cd statusengine/src
LANG=C gcc -shared -o statusengine.o -fPIC -D_GNU_SOURCE -Wall -Werror statusengine.c -luuid -levent -lgearman -ljson-c -DNAEMON;
cp statusengine.o /opt/statusengine/
cd ../../

#Install MySQL database for Statusengine
cd sql/
mysql -uroot -pvagrant < statusengine.sql
mysql -uroot -pvagrant < naemon.sql
cd ..

#Configure Apache2 web server
cp apache2/sites-available/* /etc/apache2/sites-available/
a2enmod rewrite
a2ensite statusengine
service apache2 restart
 
#Install Statusengine PHP files
cp -r cakephp /opt/statusengine/
mkdir -p /opt/statusengine/cakephp/app/tmp
chown www-data:www-data /opt/statusengine/cakephp/app/tmp -R
cp etc/init.d/statusengine /etc/init.d/statusengine
cp etc/init.d/mod_perfdata /etc/init.d/mod_perfdata
chmod +x /etc/init.d/statusengine
chmod +x /etc/init.d/mod_perfdata
chmod +x /opt/statusengine/cakephp/app/Console/cake
cd ..

#Install demo config files
cp -r statusengine_config/* /opt/statusengine/cakephp/app/Config/ 

#Load default MySQL database schema for statusengine
yes | /opt/statusengine/cakephp/app/Console/cake schema update --plugin Legacy --file legacy_schema_innodb.php --connection legacy

#Add statusengine to autostart
update-rc.d statusengine defaults
service statusengine start

#Fix permissions
chown www-data:www-data /opt/statusengine/cakephp/app/tmp -R

#Overwrite default apache index page
cp var/www/html/index.html /var/www/html/index.html

