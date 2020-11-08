#!/bin/bash

#== Import script args ==

timezone=$(echo "$1")
mysqlpass=$(echo "$2")
dbname=$(echo "$3")

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "Provision-script user: `whoami`"

set -eu

info "installing basic tools"
yum -y install net-tools
yum -y install wget
yum -y install curl

info "disabling selinux"
cp -p /etc/selinux/config /etc/selinux/config.orig
sed -i -e "s|^SELINUX=.*|SELINUX=disabled|" /etc/selinux/config
setenforce 0

info "setting timezone"
timedatectl set-timezone ${timezone}
printf "LANG=en_US.utf-8\nLC_ALL=en_US.utf-8" >> /etc/environment
yum -y reinstall glibc-common

info "turn off firewall"
service firewalld stop

info "install nginx"
yum install epel-release -y
info "install common binaries"
yum install nginx -y
sed -i 's/user nginx/user vagrant/g' /etc/nginx/nginx.conf
chkconfig nginx on
info "Enabling site configuration"
ln -s /config/vagrant/nginx/app.conf /etc/nginx/conf.d/app.conf

info "install vim"
yum install vim -y
info "install bower"
yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_10.x | sudo -E bash -
yum install nodejs -y
npm install -g bower
info "install git"
yum install git -y


info "install mysql"
wget http://repo.mysql.com/mysql57-community-release-el7.rpm -P /tmp/
rpm -ivh /tmp/mysql57-community-release-el7.rpm
yum update mysql -y
yum install mysql-server -y
chkconfig mysqld on
service mysqld restart

systemctl set-environment MYSQLD_OPTS="--skip-grant-tables"
service mysqld restart
mysql -u root -e "UPDATE mysql.user SET authentication_string = PASSWORD('${mysqlpass}') WHERE User = 'root' AND Host = 'localhost'; FLUSH PRIVILEGES; ALTER USER 'root'@'localhost' IDENTIFIED BY '${mysqlpass}';"
systemctl unset-environment MYSQLD_OPTS
service mysqld restart
mysql -uroot -p${mysqlpass} -e "CREATE DATABASE ${dbname} CHARACTER SET utf8 COLLATE utf8_unicode_ci" --connect-expired-password;

info "install php-fpm"
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum install yum-utils -y
yum-config-manager --enable remi-php72
yum install php php-cli php-common php-fpm php-gd php-intl php-json php-ldap php-mbstring php-mysqlnd php-pdo php-pecl-igbinary php-pecl-imagick php-pecl-mcrypt php-pecl-redis4 php-pecl-zip php-soap php-xml php-mcrypt php-curl php-mysql php-zip php-fileinfo -y
sed -i 's/user = apache/user = vagrant/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = vagrant/g' /etc/php-fpm.d/www.conf
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 1024M/g' /etc/php.ini
chown -R vagrant:vagrant /var/lib/php/session
systemctl enable php-fpm


info "install Composer"
yum -y update
cd /tmp
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer
composer self-update 1.10.6

#info "install elasticsearch"
#yum install java -y
#wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.3.rpm
#rpm -ivh elasticsearch-5.4.3.rpm
#mkdir -p /data/es/data
#mkdir -p /data/es/logs
#chown -R elasticsearch:elasticsearch /data/es
#/usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu
#systemctl enable elasticsearch
#sed -i 's/#path.data: \/path\/to\/data/path.data: \/data\/es\/data/g' /etc/elasticsearch/elasticsearch.yml
#sed -i 's/#path.data: \/path\/to\/logs/path.data: \/data\/es\/logs/g' /etc/elasticsearch/elasticsearch.yml
#sed -i 's/#http.port: 9200/http.port: 9200/g' /etc/elasticsearch/elasticsearch.yml
