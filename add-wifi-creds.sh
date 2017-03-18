#!/bin/bash
if (( "$#" != 2 ))
then
  echo "$0: usage: add_wifi_creds.sh <ssid> <password>"
  exit 1
fi
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

echo $1
echo $2


let boot_offset="boot_sector_start*512"
let root_offset="root_sector_start*512"

sudo mkdir -p mnt/image/boot
sudo mkdir -p mnt/image/root

sudo mount -v -o offset=$boot_offset -t vfat $image_name.img mnt/image/boot 
sudo mount -v -o offset=$root_offset -t ext4 $image_name.img mnt/image/root

echo "ssh" > mnt/image/boot/ssh

ls mnt/image/boot
wifi_file=mnt/image/root/etc/wpa_supplicant/wpa_supplicant.conf
sudo sed --in-place '/network={/d' $wifi_file
sudo sed --in-place '/ssid=/d' $wifi_file
sudo sed --in-place '/psk=/d' $wifi_file
sudo sed --in-place '/}/d' $wifi_file
sudo sed -i '$ a network={' $wifi_file 
sudo sed -i "$ a     ssid=\"$1\"" $wifi_file
sudo sed -i "$ a     psk=\"$2\"" $wifi_file
sudo sed -i '$ a }' $wifi_file

cat $wifi_file

network_file=mnt/image/root/etc/network/interfaces
sudo sed --in-place '/allow-hotplug usb0/d' $network_file
sudo sed --in-place '/iface usb0 inet dhcp/d' $network_file
sudo sed -i '$ a allow-hotplug usb0' $network_file
sudo sed -i '$ a iface usb0 inet dhcp' $network_file
cat $network_file
sudo umount mnt/image/boot
sudo umount mnt/image/root
