#!/bin/sh

##use wsl2, and install ubuntu from microsoft store
##setup ubuntu defaults

## update & upgrade apt
#sudo apt update && sudo apt upgrade

##install php
#sudo apt install php

##install ubuntu related dependencies, add hhvm repo, gpg key for hhvm
#sudo apt install software-properties-common apt-transport-https
#sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xB4112585D386EB94
#add-apt-repository https://dl.hhvm.com/ubuntu
#sudo apt-get install -y curl && sudo curl https://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add - &&  sudo apt-key finger 'opensource+hhvm@fb.com'
#sudo apt update

#install zip utils (needed when installing hhvm dependencies, otherwise there will be a ton of errors shown on hh_client run)
#sudo apt install zip unzip php-zip

##now install hhvm
#sudo apt install hhvm

## download composer (to install hhvm dependencies)
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

## install composer
php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
php composer.phar update
>&2 echo 'Composer downloaded & updated'

## make .hack project dirs
mkdir bin src tests
>&2 echo '/bin, /src & /tests created'

## download .hhconfig
curl https://raw.githubusercontent.com/hhvm/hhast/master/.hhconfig > .hhconfig
>&2 echo '.hhconfig downloaded'

##create autoload.json
cat <<'EOF' > hh_autoload.json
{
  "roots": [
    "src/"
  ],
  "devRoots": [
    "tests/"
  ],
  "devFailureHandler": "Facebook\\AutoloadMap\\HHClientFallbackHandler"
}
EOF

>&2 echo 'hh_autoload.json created'

## install hhvm modules
composer require hhvm/hsl hhvm/hhvm-autoload
composer require --dev hhvm/hhast hhvm/hacktest facebook/fbexpect
>&2 echo 'Hack common dependencies added'

## test the installation
hh_client restart && hh_client
exit $RESULT