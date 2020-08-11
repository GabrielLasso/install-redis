#!/bin/bash

# Author: Gabriel Lasso<https://github.com/gabriellasso>
# Install redis in a debian machine
# Must have a redis_init_script and a redis.conf in the same directory

if [[ $(id -u) -ne 0 ]]; then
    echo "Please run as root"
    exit
fi

apt-get update
apt-get install -y wget make gcc libsystemd-dev pkg-config

wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
pushd redis-stable
make distclean
make install
popd

echo "Qual a senha que vc quer?"
read PWD

cp redis.conf redis.conf.tmp
cp redis.service redis.service.tmp
sed -i "s/{{PASSWORD}}/$PWD/g" redis.conf.tmp
sed -i "s/{{PASSWORD}}/$PWD/g" redis.service.tmp

mkdir /etc/redis
cp redis.conf.tmp /etc/redis/6379.conf
cp redis.service.tmp /etc/systemd/system/redis.service
cp disable-transparent-huge-pages.service /etc/systemd/system

sysctl vm.overcommit_memory=1
sysctl net.core.somaxconn=65535

adduser --system --group --no-create-home redis
mkdir -p /var/lib/redis/{6379,log}
chown -R redis:redis /var/lib/redis
chmod -R 770 /var/lib/redis

rm redis.conf.tmp redis.service.tmp

systemctl enable disable-transparent-huge-pages
systemctl start disable-transparent-huge-pages
systemctl status disable-transparent-huge-pages

systemctl enable redis
systemctl start redis
systemctl status redis
