#!/bin/bash
file="dependencies.txt"
while read -r line; do
   REQUIRED_PKG=$line
   PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
   echo Checking for $REQUIRED_PKG: $PKG_OK
   if [ "" = "$PKG_OK" ]; then
      echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
      sudo apt-get --yes install $REQUIRED_PKG
   fi
done <$file

