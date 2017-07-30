#!/bin/sh
#version: 1.0.2
# updated fresh install script, now installs everything needed for a portable digital station
# changed how fldigi installs, install flamp and flmsg
#taken from the NW Digital Radio group wiki on installing fldigi

FLDIGICUR=4.0.8
FLAMPCUR=2.2.03
FLMSGCUR=4.0.3

#BEFORE INSTALL, get all the deps for it!!! this takes editing the source list file and other fun stuff
sudo cp /etc/apt/sources.list /etc/apt/sources.$FLDIGICUR.bkup
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

#make sure in home directory
cd ~
#grab the scripts
git clone https://github.com/nwdigitalradio/n7nix
#install the base files
cd n7nix/config
sudo ./core_install.sh

#copy the 'default' config file
cd ~
cp ./UDRC_fresh_start/direwolf.conf ./direwolf.conf

#note: install script sets audio levels automatiaclly

#get current version of fldigi
wget -N https://sourceforge.net/projects/fldigi/files/fldigi/fldigi-$FLDIGICUR.tar.gz
tar -zxvsf fldigi-$FLDIGICUR.tar.gz
cd fldigi-$FLDIGICUR
# now we can configure and install
./configure
make
sudo make install
# cpy the desktop shortcuts
cp data/fldigi.desktop ~/Desktop/
cp data/flarq.desktop ~/Desktop/
#install flamp and flmsg
cd ~
wget -N https://sourceforge.net/projects/fldigi/files/flamp/flamp-$FLAMPCUR.tar.gz
tar -zxvsf flamp-$FLAMPCUR.tar.gz
cd flamp-$FLAMPCUR
./configure
make
sudo make install
cp data/flamp.desktop ~/Desktop
	
wget -N https://sourceforge.net/projects/fldigi/files/flmsg/flmsg-$FLMSGCUR.tar.gz
tar -zxvsf flmsg-$FLMSGCUR.tar.gz
cd flmsg-$FLMSGCUR
./configure
make
sudo make install
cp data/flmsg.desktop ~/Desktop/

#install xastir
sudo apt-get install xastir -y

#copy all config files
cp ./UDRC_fresh_start/fldigi/fldigi_def.xml ./.fldigi/fldigi_def.xml
cp ./UDRC_fresh_start/xastir/* ./.xastir/config
#cp ./UDRC_fresh_start/xastir/selected_maps.sys ./.xastir/config/selected_maps.sys
#cp ./UDRC_fresh_start/xastir/xastir.cnf ./.xastir/config/xastir.cnf

#check for udrc:
echo "checking UDRC eeprom version...."
udrc="Universal Digital Radio Controller II"
outvar=`cat /sys/firmware/devicetree/base/hat/product`
if [ "$udrc" == "$outvar"]
then
echo "yep, you have a UDRC 2"
else
echo "nope, you do not have a udrc 2, you might have to do an eeprom upgrade!"
fi
