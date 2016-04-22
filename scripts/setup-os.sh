#!/bin/bash

while getopts t: option; do
    case $option in
        t) TOTAL_NODES=$OPTARG;;
    esac
done

function disableFirewall {
     echo "Disabling the Firewall"
     sudo ufw disable
}

function installDependencies {
    sudo apt-get update
    sudo apt-get install -y --force-yes python-pip unzip tcpdump wget sshpass

    sudo pip install --upgrade pip

    echo "CREATING TEMPORARY FOLDER"
    sudo mkdir -p "/vagrant/resources/tmp"
}

function configureUlimit {
  sudo sh -c "ulimit -n 10240"
}

echo 'current user:'
whoami

configureUlimit
disableFirewall
installDependencies
