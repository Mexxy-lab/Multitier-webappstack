#!/bin/bash
sudo dnf install epel-release -y
sudo dnf install memcached -y
sudo systemctl start memcached
sudo systemctl enable memcached
sudo systemctl status memcached
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
sudo systemctl restart memcached
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo systemctl status firewalld
firewall-cmd --add-port=11211/tcp
firewall-cmd --runtime-to-permanent
firewall-cmd --add-port=11111/udp
firewall-cmd --runtime-to-permanent
sudo systemctl restart firewalld
sudo memcached -p 11211 -U 11111 -u memcached -d
sudo systemctl restart firewalld
sudo systemctl restart memcached