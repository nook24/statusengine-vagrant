#!/bin/bash
set -e
#Enable Apache config provided by Statusengine
a2ensite pnp4nagios.conf
#Install pnp4nagios without nagios3 or iconge recommends from apt-get
apt-get install -y pnp4nagios --no-install-recommends
service apache2 restart

