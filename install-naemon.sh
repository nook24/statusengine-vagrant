#!/bin/bash
set -e
useradd naemon
wget https://github.com/naemon/naemon-core/archive/v1.0.3.tar.gz
tar xfv v1.0.3.tar.gz
cd naemon-core-1.0.3/
sudo mkdir -p /opt/naemon
./autogen.sh --prefix=/opt/naemon --with-naemon-user=naemon --with-naemon-group=www-data
#./configure --prefix=/opt/naemon --with-naemon-user=naemon --with-naemon-group=www-data
make all
sudo make install
sudo make daemon-init
sudo cp daemon-init /etc/init.d/naemon
sudo chmod +x /etc/init.d/naemon
sudo echo "broker_module=/opt/statusengine/statusengine.o" >> /opt/naemon/etc/naemon/naemon.cfg
sudo echo '$USER1$=/opt/naemon/libexec' > /opt/naemon/etc/naemon/resource.cfg
cd ..
sudo chown naemon:naemon /opt/naemon/var/ -R
sudo update-rc.d naemon defaults
sudo service naemon start
