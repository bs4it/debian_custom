#!/bin/bash
iso_name="bs4it-lnxrepo-11.5.0-amd64.iso"
sudo rm -rf isofiles
mkdir isofiles
cp -rT iso_src/ isofiles/
chmod +w -R isofiles/install.amd/
gunzip isofiles/install.amd/initrd.gz
echo preseed.cfg | cpio -H newc -o -A -F isofiles/install.amd/initrd
gzip -9 isofiles/install.amd/initrd
chmod -w -R isofiles/install.amd/
cd isofiles
chmod +w md5sum.txt
find -follow -type f ! -name md5sum.txt -print0 | xargs -0 md5sum > md5sum.txt
chmod -w md5sum.txt
cd ..
xorriso -as mkisofs -r -checksum_algorithm_iso sha256,sha512 -V 'BS4IT Linux Repository 11.5.0' -o $iso_name -J -joliet-long -cache-inodes -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin -b isolinux/isolinux.bin -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus isofiles/
sha1sum $iso_name > $iso_name.sha1sum
scp $iso_name* fdts@192.168.122.1:/home/fdts/ISO/
