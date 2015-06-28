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
make install-init
cd ..
