#!/bin/sh
# this script updates a previous install script from a past install
# you should NOT use this script if you are starting out fresh!
# 

# command scratch pad:
# sudo apt-get install libxft-dev # from fldigi wiki
# sudo apt-get build-dep fldigi

#note: might need to delete current install of fldigi????
#ok, according to io group for fldigi you have to uninstall the current version, so we need to find a way to do that
#but for now lets just get it over with
cd ~/fldigi-4.0.4
sudo make uninstall
cd ..
#download and install the new one
wget -N https://sourceforge.net/projects/fldigi/files/fldigi/fldigi-4.0.6.tar.gz
tar -zxvsf fldigi-4.0.6.tar.gz
cd fldigi-4.0.6
./configure --with-portaudio
make
sudo make install
