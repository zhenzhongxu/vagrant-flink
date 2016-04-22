#!/bin/bash
FLINK_VERSION=flink-1.0.1
# So we dont need to pass in i to the scripts
NODE_NUMBER=`hostname | tr -d node`


function downloadFile {

    url="${1}"
    filename="${2}"

    mkdir -p /vagrant/resources/tmp
    cached_file="/vagrant/resources/tmp/${filename}"

    if [ ! -e $cached_file ]; then
        echo "Downloading ${filename} from ${url} to ${cached_file}"
        echo "This will take some time. Please be patient..."
        wget -nv -O $cached_file $url
    fi

    TARBALL=$cached_file
}

function downloadApacheFile {

    project="${1}"
    version="${2}"
    filename="${3}"

    closest_url=`python /vagrant/scripts/closest-mirror.py ${project} -v ${version} -f ${filename}`

    downloadFile $closest_url $filename
}

function join {
    local IFS="$1"; shift; echo "$*"
}

function generateZkString {
    # Yes its ugly, but so is bash :)
    ZK_STRING=`python -c "print ','.join([ 'node{0}:2181'.format(x) for x in range(2,${1}+1)])"`
}

function generateZkStringNoPorts {
    ZK_STRING_NOPORTS=`python -c "print ','.join([ 'node{0}'.format(x) for x in range(2,${1}+1)])"`
}

function safeSymLink {
    target=$1
    symlink=$2

    if [ -e $symlink ]; then
        echo "${symlink} exists. Deleting."
        sudo rm $symlink
    fi

    sudo ln -s $target $symlink
}

function commentLine {
    line="${1}"
    file="${2}"

    echo "Commenting out '${line}' from ${file}"
    sudo sed -i "s/^${line}/# ${line}/" $file
}
