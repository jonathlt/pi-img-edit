#!/bin/bash
echo "$(whoami)"
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"
image_url="https://downloads.raspberrypi.org/raspbian_lite_latest"
image_name="2017-03-02-raspbian-jessie-lite"
zip_name=${image_name}.zip
mkdir -p tmpfiles
cd tmpfiles
wget -c $image_url -O $zip_name
unzip -n $zip_name
boot_sector_start=$(fdisk -l $image_name.img | awk '/FAT32/ {print $2}')
root_sector_start=$(fdisk -l $image_name.img | awk '/Linux/ {print $2}')

echo $boot_sector_start
echo $root_sector_start

sudo mkdir -p mnt/image/boot
sudo mkdir -p mnt/image/root