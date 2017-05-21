#!/bin/sh
#taken from the NW Digital Radio group wiki on installing fldigi
#update the pi:
sudo apt-get update
sudo apt-get upgrade -y

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

# install fldigi libraries and headerfiles
sudo apt-get install libfltk1.3-dev libsamplerate0-dev portaudio19-dev -y

#get current version of fldigi
wget -N https://sourceforge.net/projects/fldigi/files/fldigi/fldigi-4.0.4.tar.gz
tar -zxvsf fldigi-4.0.4.tar.gz
cd fldigi-4.0.4
./configure --with-portaudio
make
sudo make install

#install xastir
sudo apt-get install xastir -y

#copy all shortcuts to desktop for easy access:
cd ~
cp ./UDRC_fresh_start/desktop/fldigi.desktop ./Desktop/fldigi.desktop
cp ./UDRC_fresh_start/desktop/direwolf.desktop ./Desktop/direwolf.desktop
cp ./UDRC_fresh_start/desktop/xastir.desktop ./Desktop/xastir.desktop

#copy all config files
cp ./UDRC_fresh_start/fldigi/fldigi_def.xml ./.fldigi/fldigi_def.xml
cp ./UDRC_fresh_start/xastir/selected_maps.sys ./.xastir/config/selected_maps.sys
cp ./UDRC_fresh_start/xastir/xastir.cnf ./.xastir/config/xastir.cnf
