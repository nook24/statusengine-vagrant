#!/bin/bash

#Thanks to: http://askubuntu.com/questions/560412/displaying-ip-address-on-eth0-interface
ip=`ifconfig eth1 | grep 'inet addr' | cut -d ':' -f 2 | cut -d ' ' -f 1`

echo "--------------------------"
echo -e "Setup done"
echo "MySQL Username: root Passwort: vagrant"
echo "SSH: ssh vagrant@127.0.0.1 -p 2222 Passwort: vagrant"
echo "Statusengine interface user: admin password: admin"
echo "Open your browser and navigate to $ip/statusengine to visit Statusengine Interface"
echo "If the ip is not working you can use localhost:8080/statusengine"
echo "--------------------------"
echo "Nice to know vagrant commands:"
echo "vagrant ssh      - Open a shell via ssh"
echo "vagrant halt     - Poweroff the vm"
echo "vagrant destroy  - Factory reset the vm"
echo "vagrant up       - Start the vm or reinstall it after factory reset"
echo "--------------------------"
