#!/bin/bash
set -e
sudo a2enmod pnp4nagios
sudo apt-get install -y pnp4nagios --no-install-recommends
sudo service apache2 restart
