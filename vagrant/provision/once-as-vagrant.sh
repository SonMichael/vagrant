#!/usr/bin/env bash

#== Import script args ==

github_token=$(echo "$1")

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "Provision-script user: `whoami`"

info "Configure composer"
composer config --global github-oauth.github.com ${github_token}

info "Install plugins for composer"
composer global require "fxp/composer-asset-plugin:^1.2.0" --no-progress

info "Install project dependencies"
cd /app/backend.kynaforkids.v2
composer --no-progress --prefer-dist install

info "Init project"
php init --env=Local --overwrite=y

#info "Apply migrations"
#php yii migrate <<< "yes"

#info "Init data"
#php yii live-init-data <<< 'y'

info "Enabling colorized prompt for guest console"
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /home/vagrant/.bashrc
