#!/bin/bash
set -e
wget github
mkdir -p /opt/statusengine
mkdir -p /var/lib/pnp4nagios/perfdata/
cd statusengine/src
LANG=C gcc -shared -o statusengine.o -fPIC  -Wall -Werror statusengine.c -luuid -levent -lgearman -ljson-c -DNAEMON;
cp statusengine.o /opt/statusengine/
cd ../../
cp -r cakephp /opt/statusengine/
cp etc/init.d/statusengine /etc/init.d/statusengine
cp etc/init.d/mod_perfdata /etc/init.d/mod_perfdata
chmod +x /etc/init.d/statusengine
chmod +x /etc/init.d/mod_perfdata
chmod +x /opt/statusengine/cakephp/app/Console/cake
cd ..

cp -r statusengine_config/* /opt/statusengine/cakephp/app/Config/ 

update-rc.d statusengine defaults
service statusengine start
