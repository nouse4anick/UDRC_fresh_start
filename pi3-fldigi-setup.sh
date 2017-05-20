#!/bin/sh
# install HamPi-FLDIGI(3.23.13)
#K3HTK 6-27-2016
#Visit http://www.indyham.com

sudo apt-get -y update 
sudo apt-get -y upgrade
sudo apt-get -y install git cmake build-essential libusb-1.0-0.dev libltdl-dev libusb-1.0-0 libhamlib-utils libsamplerate0 libsamplerate0-dev libsigx-2.0-dev libsigc++-1.2-dev libpopt-dev tcl8.5-dev libspeex-dev libasound2-dev alsa-utils libgcrypt11-dev libpopt-dev libfltk1.3-dev libpng++-dev libportaudio-dev libpulse-dev libportaudiocpp0 ||
	{ echo 'apt-get failed'; exit 1;}

mkdir -p /home/pi/HamPi-FLDIGI && cd HamPi-FLDIGI || 
	{ echo 'Can not create dir'; exit 1; }

wget -N http://sourceforge.net/projects/hamlib/files/hamlib/3.0.1/hamlib-3.0.1.tar.gz ||
  { echo 'Can not get HamLib file'; exit 1; }
  
tar -xvzf hamlib*
cd hamlib*
./configure && make && sudo make install ||
  { echo 'Can not install HamLib'; exit 1; }
sudo ldconfig

sudo apt-get -y install portaudio19-dev ||
	{ echo 'apt-get failed'; exit 1;}

cd .. && wget -N https://sourceforge.net/projects/fldigi/files/fldigi/fldigi-4.0.4.tar.gz ||
  { echo 'Can not get fldigi file'; exit 1; }

tar kxzf fldigi-4.0.4.tar.gz && cd fldigi-4.0.4 ||
  { echo 'Can not extract fldigi'; exit 1; }

./configure --with-portaudio && make && sudo make install ||
  { echo 'Can not install fldigi'; exit 1; }

cd .. && wget -N http://www.elazary.com/images/mediaFiles/ham/hampi/setGPIO ||
  { echo 'Can not get setGPIO'; exit 1; }

if ! grep -q setGPIO ~/.bashrc  ; then 
  echo "sudo sh /home/pi/HamPi-FLDIGI/setGPIO" >> ~/.bashrc
fi

if ! grep -q snd-mixer-oss /etc/modules  ; then 
  sudo sh -c "echo snd-mixer-oss >> /etc/modules"
fi

if ! grep -q snd-pcm-oss /etc/modules  ; then 
  sudo sh -c "echo snd-pcm-oss >> /etc/modules"
fi

echo "[Desktop Entry]
Name=Fldigi
GenericName=Amateur Radio Digital Modem
Comment=Amateur Radio Sound Card Communications
Exec=fldigi
Icon=fldigi
Terminal=false
Type=Application
Categories=Network;HamRadio;" > /home/pi/Desktop/fldigi.desktop ||
   { echo 'can not setup fldigi icon'; exit 1;}
