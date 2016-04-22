#!/bin/bash

source "/vagrant/scripts/common.sh"


while getopts t:r: option; do
    case $option in
        t) TOTAL_NODES=$OPTARG;;
    esac
done


function installFlink {
    sudo mkdir -p /app
    sudo chown vagrant /app
    downloadApacheFile flink ${FLINK_VERSION} "${FLINK_VERSION}-bin-hadoop2-scala_2.11.tgz"

    echo "untaring ${TARBALL}"
    tar -oxzf $TARBALL -C /app
    safeSymLink "/app/${FLINK_VERSION}" /app/flink

    sudo mkdir -p /var/log/flink
}

function configureFlink {
    echo "Configuring Flink"

    sed -i 's/jobmanager.rpc.address.*/jobmanager.rpc.address: 192.168.10.100/' /app/flink/conf/flink-conf.yaml

    rm /app/flink/conf/slaves

    seq -f "192.168.10.1%02g" ${TOTAL_NODES} >> /app/flink/conf/slaves
}

echo "Setting up Flink"
installFlink
configureFlink
