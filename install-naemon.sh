#!/bin/bash
set -e
#Create Naemon user
useradd naemon

#Download and compile Naemon-Core
wget https://github.com/naemon/naemon-core/archive/v1.0.3.tar.gz --no-verbose
tar xfv v1.0.3.tar.gz
cd naemon-core-1.0.3/
mkdir -p /opt/naemon
./autogen.sh --prefix=/opt/naemon --with-naemon-user=naemon --with-naemon-group=www-data
#./configure --prefix=/opt/naemon --with-naemon-user=naemon --with-naemon-group=www-data
make all
make install

#Install Naemon init script
make daemon-init
cp daemon-init /etc/init.d/naemon
chmod +x /etc/init.d/naemon

#Add Statusengine event broker module to naemon.cfg
echo "broker_module=/opt/statusengine/statusengine.o /opt/statusengine/statusengine.json" >> /opt/naemon/etc/naemon/naemon.cfg

#Fix Naemons resource.cfg for demo config
echo '$USER1$=/opt/naemon/libexec' > /opt/naemon/etc/naemon/resource.cfg
cd ..
chown naemon:naemon /opt/naemon/var/ -R

#Install demo config
rm -r /opt/naemon/etc/naemon/conf.d/*
cp -r naemon_config/* /opt/naemon/etc/naemon/conf.d/ 

#Add naemon to autostart
update-rc.d naemon defaults
service naemon start

