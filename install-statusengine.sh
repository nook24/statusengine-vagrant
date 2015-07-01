#!/bin/bash
set -e

#wget https://github.com/nook24/statusengine/archive/1.4.2.tar.gz
#tar xfv 1.4.2.tar.gz
#cd statusengine-1.4.2/

wget https://github.com/nook24/statusengine/archive/master.zip
unzip master.zip
cd statusengine-master/

sudo mkdir -p /opt/statusengine
sudo mkdir -p /var/lib/pnp4nagios/perfdata/
cd statusengine/src
LANG=C gcc -shared -o statusengine.o -fPIC  -Wall -Werror statusengine.c -luuid -levent -lgearman -ljson-c -DNAEMON;
cp statusengine.o /opt/statusengine/
cd ../../
cd sql/
mysql -uroot -pvagrant < statusengine.sql
mysql -uroot -pvagrant < nagios.sql
cd ..

sudo cp apache2/sites-available/* /etc/apache2/sites-available/
a2enmod rewrite
a2ensite statusengine
service apache2 restart
 
sudo cp -r cakephp /opt/statusengine/
sudo mkdir -p /opt/statusengine/cakephp/app/tmp
sudo chown www:data:www-data /opt/statusengine/cakephp/app/tmp -R
sudo cp etc/init.d/statusengine /etc/init.d/statusengine
sudo cp etc/init.d/mod_perfdata /etc/init.d/mod_perfdata
sudo chmod +x /etc/init.d/statusengine
sudo chmod +x /etc/init.d/mod_perfdata
sudo chmod +x /opt/statusengine/cakephp/app/Console/cake
cd ..

sudo cp -r statusengine_config/* /opt/statusengine/cakephp/app/Config/ 

yes | /opt/statusengine/cakephp/app/Console/cake schema update --plugin Legacy --file legacy_schema_innodb.php --connection legacy

sudo update-rc.d statusengine defaults
sudo service statusengine start

sudo chown www:data:www-data /opt/statusengine/cakephp/app/tmp -R
