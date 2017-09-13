#!/bin/bash

set -e
set -x

# Build and install the CLI tools
echo "\n\n======= Build and install SON-CLI =======\n\n"

# we want to use son-workspace and son-access
# permissions problems happen when we use the git repo pulled by Jenkins, we need to pull it ourselves
git clone https://github.com/sonata-nfv/son-cli.git
# ensure the next steps are performed on the cli master
#git checkout cli/master
cd son-cli

# make sure docker is installed
# sudo apt-get install -o Dpkg::Options::="--force-confold" --force-yes -y curl
# sudo curl -fsSL https://get.docker.com/gpg | apt-key add -
# sudo curl -fsSL https://get.docker.com/ | sh

# update sources
sudo apt-get update
# needed to build pyYAML (libyaml is optional but recommended)
sudo apt-get install -o Dpkg::Options::="--force-confold" --force-yes -y build-essential python3-dev python3-pip libyaml-dev libffi-dev libssl-dev

# install son-monitor dependencies
sudo apt-get install -y gfortran libopenblas-dev liblapack-dev
sudo apt-get build-dep -y python3-matplotlib

# update setuptools
# sudo apt-get remove -y python3-setuptools
# sudo wget https://bootstrap.pypa.io/get-pip.py
# sudo python3 get-pip.py
# sudo pip3 install setuptools --upgrade

# install dependencies
sudo pip3 install virtualenv
virtualenv -p /usr/bin/python3 venv
source venv/bin/activate

sudo pip3 install numpy
sudo pip3 install scipy
sudo pip3 install docker==2.0.2
sudo pip3 install matplotlib
sudo pip3 install Flask
sudo pip3 install urllib3==1.21.1
echo "\n\n\n all the warnings above should be ignored \n\n\n"

python3 setup.py install
# python3 bootstrap.py

echo "\n\n\n try son-access \n\n\n"
son-access -h

#bin/buildout
#bin/py.test -s -v

#echo "\n\n performing system wide install \n\n"

#sudo pip3 install .
#sudo python3 setup.py develop
