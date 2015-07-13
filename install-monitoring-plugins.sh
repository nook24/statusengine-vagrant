#!/bin/bash
set -e
#Download compile and install monitoring plugins
wget https://github.com/monitoring-plugins/monitoring-plugins/archive/v2.1.1.tar.gz
tar xfv v2.1.1.tar.gz
cd monitoring-plugins-2.1.1/
./autogen.sh --prefix=/opt/naemon
#./configure --prefix=/opt/naemon
make all
make install
cd ..

