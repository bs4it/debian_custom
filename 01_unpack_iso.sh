#!/bin/bash
# cria arquivo de configuracao

sourceiso="debian-11.5.0-amd64-netinst.iso"


cat << EOF > ./config-deb

# A config-deb file.

# Points to where the unpacked DVD-1 is.
Dir {
    ArchiveDir "iso_src";
  #  OverrideDir "iso_src/indices/override";
  #  CacheDir "indices";
};


# Sets the top of the .deb directory tree.
TreeDefault {
   Directory "pool/";
};

# The location for a Packages file.                
BinDirectory "pool/main" {
   Packages "dists/bullseye/main/binary-amd64/Packages";
 #  BinOverride "override.bullseye.main";
 #  ExtraOverride "override.extra";
};

# We are only interested in .deb files (.udeb for udeb files).                                
Default {
   Packages {
       Extensions ".deb";
    };
};
EOF

mkdir ./iso_src
bsdtar -C ./iso_src/ -xf $sourceiso
chmod -R +w ./iso_src
#mkdir -p ~/iso_src/indices/override
#touch ~/iso_src/indices/override/override.extra
#curl -o ~/iso_src/indices/override/override.bullseye.main.gz http://deb.debian.org/debian/indices/override.bullseye.main.gz
#gunzip -f ~/iso_src/indices/override/override.bullseye.main.gz

echo "Ready to add files to repo"

# Generate Packages.gz
#apt-ftparchive generate ~/config-deb

# Regenerate Release

#sed -i '/MD5Sum:/,$d' ~/iso_src/dists/bullseye/Release
#apt-ftparchive release ~/iso_src/dists/bullseye >> cd/dists/bullseye/Release

# Regenerate md5sum.txt
#cd ~/iso_src; md5sum `find ! -name "md5sum.txt" ! -path "./isolinux/*" -follow -type f` > md5sum.txt; cd ..

#chmod -R -w ~/iso_src

