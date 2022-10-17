#!/bin/bash
# cria arquivo de configuracao

#sourceiso="debian-11.4.0-amd64-netinst.iso"


chmod -R +w ./iso_src
# Generate Packages.gz
apt-ftparchive generate ./config-deb

# Regenerate Release

sed -i '/MD5Sum:/,$d' ./iso_src/dists/bullseye/Release
apt-ftparchive release ./iso_src/dists/bullseye >> ./iso_src/dists/bullseye/Release

# Regenerate md5sum.txt
#cd ~/iso_src; md5sum `find ! -name "md5sum.txt" ! -path "./isolinux/*" -follow -type f` > md5sum.txt; cd ..
cd ./iso_src; find -follow -type f ! -name md5sum.txt -! -path "./isolinux/* " -print0 | xargs -0 md5sum > md5sum.txt; cd ..

chmod -R -w ./iso_src

echo "Ready to create ISO or add Preseed"
