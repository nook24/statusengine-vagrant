#!/bin/bash
set -e
a2ensite pnp4nagios.conf
apt-get install -y pnp4nagios --no-install-recommends
service apache2 restart
