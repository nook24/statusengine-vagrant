#!/bin/bash
set -e
useradd naemon
wget https://github.com/naemon/naemon-core/archive/v1.0.3.tar.gz
tar xfv v1.0.3.tar.gz
cd naemon-core-1.0.3/
mkdir -p /opt/naemon
./autogen.sh --prefix=/opt/naemon --with-naemon-user=naemon --with-naemon-group=www-data
#./configure --prefix=/opt/naemon --with-naemon-user=naemon --with-naemon-group=www-data
make all
make install
make daemon-init
cp daemon-init /etc/init.d/naemon
chmod +x /etc/init.d/naemon
echo "broker_module=/opt/statusengine/statusengine.o" >> /opt/naemon/etc/naemon/naemon.cfg
echo '$USER1$=/opt/naemon/libexec' > /opt/naemon/etc/naemon/resource.cfg
cd ..
chown naemon:naemon /opt/naemon/var/ -R
rm -r /opt/naemon/etc/naemon/conf.d/*
cp -r naemon_config/* /opt/naemon/etc/naemon/conf.d/ 
update-rc.d naemon defaults
service naemon start
