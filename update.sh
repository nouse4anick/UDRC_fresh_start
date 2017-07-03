#!/bin/sh
# this script updates a previous install script from a past install
# you should NOT use this script if you are starting out fresh!
# 

# command scratch pad:
# sudo apt-get install libxft-dev # from fldigi wiki
# sudo apt-get build-dep fldigi
#sudo apt-get -y install git cmake build-essential libusb-1.0-0.dev libltdl-dev libusb-1.0-0 libhamlib-utils libsamplerate0 libsamplerate0-dev libsigx-2.0-dev libsigc++-1.2-dev libpopt-dev tcl8.5-dev libspeex-dev libasound2-dev alsa-utils libgcrypt11-dev libpopt-dev libfltk1.3-dev libpng++-dev libportaudio-dev libpulse-dev libportaudiocpp0

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
#BEFORE INSTALL, get all the deps for it!!! this takes editing the source list file and other fun stuff
sudo cp /etc/apt/sources.list /etc/apt/sources.4.0.6.bkup
#dirty way of doing it
echo  "deb http://mirrordirector.raspbian.org/raspbian/ jessie main contrib non-free rpi
# Uncomment line below then 'apt-get update' to enable 'apt-get source'
deb-src http://archive.raspbian.org/raspbian/ jessie main contrib non-free rpi
" | sudo tee /etc/apt/sources.list
echo "sources.list backed up to sources.4.0.6.bkup, please add any other sources from the old file to the new one that are not already in there"
#tried to use sed and tee to remove the 3rd line but no go =(
#best method would be to just append the deb-src line to the bottom of the list but that also has issues
#sudo sed '3,3s/.//' /etc/apt/sources.list | sudo tee /etc/apt/sources.list

#update and build the deps for fldigi
sudo apt-get update
sudo apt-get build-dep fldigi -y
# now we can configure and install
./configure
make
sudo make install

#install flamp and flmsg

cd ..
wget -N https://sourceforge.net/projects/fldigi/files/flamp/flamp-2.2.03.tar.gz
wget -N https://sourceforge.net/projects/fldigi/files/flmsg/flmsg-4.0.2.tar.gz
tar -zxvsf flamp-2.2.03.tar.gz
tar -zxvsf flmsg-4.0.2.tar.gz

cd flamp-2.2.03
./configure
make
sudo make install

cd ../flmsg-4.0.2
./configure
make
sudo make install
