#!/bin/bash
set -e
wget https://github.com/monitoring-plugins/monitoring-plugins/archive/v2.1.1.tar.gz
tar xfv v2.1.1.tar.gz
cd monitoring-plugins-2.1.1/
./autogen.sh
./configure --prefix=/opt/naemon
make all
make install
cd ..
