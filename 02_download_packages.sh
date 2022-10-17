#!/bin/bash
#apt install dctrl-tools
repo_url="http://deb.debian.org/debian/"
dist="bullseye"
local_path="iso_src"
local_packages=($(find $local_path/pool -name *.deb -exec basename {} \; | cut -d "_" -f 1))
packages_to_add=( openssh-server vim git wget python3 net-tools vim tcpdump iptraf-ng htop sysstat lvm2 xfsprogs open-iscsi lsscsi scsitools gdisk nfs-common sudo tmux ufw curl dialog ifenslave ethtool bind9-dnsutils open-vm-tools hyperv-daemons qemu-guest-agent )


#Download Packages from repo
curl $repo_url/dists/$dist/main/binary-amd64/Packages.gz | gunzip > Packages.repo

echo "Building dependencies for ${packages_to_add[@]}"
dependencies=($(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances ${packages_to_add[@]} | grep "^\w" | sort -u))
# for each dependencie needed
for d in ${dependencies[@]}
do
    download=1
    for lp in ${local_packages[@]}
    do
        if [[ $d == "$lp" ]]; then
            download=0
        fi
    done
    if [[ $download -eq 1 ]]; then
        file=$(grep-dctrl -P $d -X -s Filename -n Packages.repo)
        echo "Downloading $d"
        mkdir -p $local_path/$(dirname $file)
        curl -# $repo_url/$file --output $local_path/$file
    fi
done
