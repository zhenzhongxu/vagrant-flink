#!/bin/bash

source "/vagrant/scripts/common.sh"

function installJava {
    sudo add-apt-repository -y ppa:webupd8team/java
    sudo apt-get update
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
    sudo apt-get install -y oracle-java8-installer

    # print version
    echo "Checking java version"
    java -version
}

function setupEnvVars {
    echo "creating java environment variables"
    sudo sh -c "echo export JAVA_HOME=/usr/java/default > /etc/profile.d/java.sh"
    sudo sh -c "echo export PATH=\${JAVA_HOME}/bin:\${PATH} >> /etc/profile.d/java.sh"
}

echo "Setting Up Java"
installJava
setupEnvVars
