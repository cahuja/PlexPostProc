#!/bin/sh

curl -o /tmp/pms.deb -L $1
sudo dpkg -i /tmp/pms.deb
rm /tmp/pms.deb
