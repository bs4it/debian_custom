#!/bin/bash
repo_url="http://deb.debian.org/debian/"
dist="bullseye"
local_path="iso_src"
packages_to_add=( sox )
#apt install dctrl-tools

#Download Packages from repo
curl $repo_url/dists/$dist/main/binary-amd64/Packages.gz | gunzip > Packages.repo

echo "Building dependencies for ${packages_to_add[@]}"
dependencies=$(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances ${packages_to_add[@]} | grep "^\w" | sort -u)
for p in $dependencies
do
    file=$(grep-dctrl -P $p -X -s Filename -n Packages.repo)
    echo "Downloading $p"
    mkdir -p $local_path/$(dirname $file)
    curl -# $repo_url/$file --output $local_path/$file
done



jatem=($(find . -name *.deb -exec basename {} \; | cut -d "_" -f 1))

for item in "${jatem[@]}"; do [[ $var == "$item" ]] && echo "$var present in the array"; done