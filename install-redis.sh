#!/bin/bash

# Author: Gabriel Lasso<https://github.com/gabriellasso>
# Install redis in a debian machine
# Must have a redis_init_script and a redis.conf in the same directory

if [[ $(id -u) -ne 0 ]]; then
    echo "Please run as root"
    exit
fi

apt-get update
apt-get install -y wget make gcc

wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
pushd redis-stable
make distclean
make install
popd

echo "Qual a senha que vc quer?"
read PWD

sed -e "s/{{PASSWORD}}/$PWD/g"
cp redis.conf redis.conf.tmp

mkdir /etc/redis
mkdir /var/redis
mkdir /var/redis/6379

cp redis_init_script /etc/init.d/redis_6379
cp redis.conf.tmp /etc/redis/6379.conf

rm redis.conf.tmb

update-rc.d redis_6379 defaults
/etc/init.d/redis_6379 start
