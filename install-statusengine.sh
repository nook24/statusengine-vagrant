#!/bin/bash
set -e

#wget https://github.com/nook24/statusengine/archive/1.4.2.tar.gz
#tar xfv 1.4.2.tar.gz
#cd statusengine-1.4.2/

wget https://github.com/nook24/statusengine/archive/master.zip
unzip master.zip
cd statusengine-master/

mkdir -p /opt/statusengine
mkdir -p /var/lib/pnp4nagios/perfdata/
cd statusengine/src
LANG=C gcc -shared -o statusengine.o -fPIC  -Wall -Werror statusengine.c -luuid -levent -lgearman -ljson-c -DNAEMON;
cp statusengine.o /opt/statusengine/
cd ../../
cd sql/
mysql -uroot -pvagrant < statusengine.sql
mysql -uroot -pvagrant < nagios.sql
cd ..

cp apache2/sites-available/* /etc/apache2/sites-available/
a2enmod rewrite
a2ensite statusengine
service apache2 restart
 
cp -r cakephp /opt/statusengine/
mkdir -p /opt/statusengine/cakephp/app/tmp
chown www-data:www-data /opt/statusengine/cakephp/app/tmp -R
cp etc/init.d/statusengine /etc/init.d/statusengine
cp etc/init.d/mod_perfdata /etc/init.d/mod_perfdata
chmod +x /etc/init.d/statusengine
chmod +x /etc/init.d/mod_perfdata
chmod +x /opt/statusengine/cakephp/app/Console/cake
cd ..

cp -r statusengine_config/* /opt/statusengine/cakephp/app/Config/ 

yes | /opt/statusengine/cakephp/app/Console/cake schema update --plugin Legacy --file legacy_schema_innodb.php --connection legacy

update-rc.d statusengine defaults
service statusengine start

chown www-data:www-data /opt/statusengine/cakephp/app/tmp -R
