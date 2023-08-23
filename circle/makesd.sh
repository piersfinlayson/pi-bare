#!/usr/bin/bash
set -e

if [ -z $2 ] || [ -z $1 ] ; then
  echo "Usage: $0 32|64 sd_card_path sample [clean]"
  exit
fi
if [ $1 = '-?' ] || [ $1 = '-h' ]; then
  echo "Usage: $0 32|64 sd_card_path sample clean"
  exit
fi
if [ $2 = '/dev/sda' ]; then
  echo "You probably don't want me to overwrite /dev/sda"
  exit
fi

ARCH=$1
SDCARD=$2
SAMPLE=$3
CLEAN=$4

RASPI='3'
TOOLCHAIN_DIR="/home/pdf/container-data/builds"
if [ $1 = '32' ]; then
  ARCH_SUBST="arm"
  ELF_EABI="eabi"
  IMG="kernel8-32.img"
elif [ $1 = '64' ]; then
  ARCH_SUBST="aarch64"
  ELF_EABI="elf"
  IMG="kernel8.img"
else 
  echo "Invalid architecture $ARCH, use 32 or 64"
  exit
fi

PREFIX="$TOOLCHAIN_DIR/arm-gnu-toolchain-12.3.rel1-x86_64-$ARCH_SUBST-none-$ELF_EABI/bin/$ARCH_SUBST-none-$ELF_EABI-"

# Set up build env
./configure -f -r $RASPI -p $PREFIX
if [ ! -z $CLEAN ] && [ $CLEAN = "clean" ]; then
  echo "Cleaning"
  ./makeall clean
  cd boot
  echo "Cleaning boot"
  make clean
  cd ..
fi

# Get the firmware
cd boot
if [ ! -f "LICENCE.broadcom" ]; then
  make firmware
fi
cd ..

# Do the main build
./makeall
cd sample/$SAMPLE
make
cd ../..

# Set up the SD card partition
echo
echo "Now write the SD card"
set +e
echo "Force unmount ${SDCARD}1 if already mounted"
sudo umount ${SDCARD}1
set -e
sudo wipefs -q --all --force $SDCARD
sudo parted -s $SDCARD mklabel msdos
sudo parted -s $SDCARD mkpart primary fat32 1MiB 100%
sudo mkfs -t vfat ${SDCARD}1 1> /dev/null

# Mount SD card and copy in files
MNT_DIR="/tmp/circle-mnt"
mkdir -p $MNT_DIR
set +e
echo "Force unmount $MNT_DIR if already mounted"
sudo umount $MNT_DIR
set -e
sudo mount ${SDCARD}1 $MNT_DIR
sudo cp boot/LICENCE.broadcom $MNT_DIR/
sudo cp boot/COPYING.linux $MNT_DIR/
sudo cp boot/*.elf $MNT_DIR/
sudo cp boot/*.dat $MNT_DIR/
sudo cp boot/*.dtb $MNT_DIR/
sudo cp boot/*.bin $MNT_DIR/
sudo cp boot/config$ARCH.txt $MNT_DIR/config.txt
sudo cp sample/$SAMPLE/kernel*.img $MNT_DIR/
echo "All files created on SD Card: $SDCARD"
find $MNT_DIR -type f | xargs ls -ltr
sudo umount -l ${SDCARD}1
rm -r $MNT_DIR

echo "Done"

