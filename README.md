# Quick Start Instructions (Getting HHVM 2.5.5 running on WSL2)

## - Install wsl2
## - Install ubuntu from microsoft store
`latest LTS preferred`

## - Setup ubuntu defaults
`user, password, etc`

## - Update & upgrade apt
`sudo apt update && sudo apt upgrade`

## - Install php
`sudo apt install php`

## - Install ubuntu related dependencies
`sudo apt install software-properties-common apt-transport-https`

## - add key for hhvm (this key may change, check https://hacklang.org for updates)
`sudo apt-get install -y curl && sudo curl https://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add - &&  sudo apt-key finger 'opensource+hhvm@fb.com'`
### OR
`sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xB4112585D386EB94`

## - Add hhvm repo
`sudo add-apt-repository https://dl.hhvm.com/ubuntu`

## - Update apt to load the new repo
`sudo apt update`

## - Install zip utils (needed when installing hhvm dependencies, otherwise there will be a ton of errors shown on hh_client run)
`sudo apt install zip unzip php-zip`

## - Install hhvm
`sudo apt install hhvm`

## - Run the hack_install script
`./hack_install.sh`