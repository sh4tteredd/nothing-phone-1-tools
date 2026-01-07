#!/usr/bin/env bash

check_adb() {
    if ! command -v fastboot > /dev/null; then
        echo "Android Platform Tools are not installed!"
        echo "In order to use this script please install the android platform tools from your package manager"
        exit 1
    fi
}

check_adb

echo "nothing phone(1) fastboot flash by @sh4tteredd"
echo ""
echo "DON'T flash a nothingOS version lower than that one that's currently installed on the phone!"
echo ""
echo "In order to gather all the files that we need, consider to run my other script available on https://github.com/sh4tteredd/nothing-phone-1-tools"
echo ""
echo "Instead, if you already have the .img files, put all your files in a subfolder called 'images' to continue"
echo ""

read -p "Now connect your phone in fastboot mode to the PC via USB, then press enter to continue"

# Device check
if fastboot getvar product 2>&1 | grep -qE "^product: *(lahaina|Spacewar)"; then
    echo "This script is only for nothing phone(1)"
    exit 1
fi

# Images folder check
if [ ! -d "./images/" ]; then
    echo "The images subfolder does not exists, check your files first!"
    exit 1
fi

FASTBOOT="fastboot"
IMG="./images"

boot_partitions="boot vendor_boot dtbo"
firmware_partitions="abl aop bluetooth cpucp devcfg dsp featenabler hyp imagefv keymaster modem multiimgoem qupfw shrm tz uefisecapp xbl xbl_config"
logical_partitions="system system_ext product vendor odm"
vbmeta_partitions="vbmeta vbmeta_system"

flash() {
    $FASTBOOT flash "$1" "$IMG/$2" || {
        echo "Failed flashing $1"
        exit 1
    }
}

echo ""
echo "Wiping data..."
$FASTBOOT -w

#################################
# SLOT A
#################################
$FASTBOOT --set-active=a
echo "Flashing A slot. Please wait..."
echo ""

# BOOTLOADER PARTITIONS
for p in $boot_partitions; do
    flash "${p}_a" "${p}.img"
done

# FASTBOOTD (firmware + logical)
$FASTBOOT reboot fastboot

for p in $firmware_partitions; do
    flash "${p}_a" "${p}.img"
done

for p in $logical_partitions; do
    flash "${p}_a" "${p}.img"
done

# BACK TO BOOTLOADER (vbmeta)
$FASTBOOT reboot bootloader

for p in $vbmeta_partitions; do
    flash "${p}_a" "${p}.img"
done

#################################
# SLOT B
#################################
$FASTBOOT --set-active=b
echo ""
echo "Flashing B slot. Please wait..."
echo ""

# BOOTLOADER PARTITIONS
for p in $boot_partitions; do
    flash "${p}_b" "${p}.img"
done

# FASTBOOTD (firmware + logical)
$FASTBOOT reboot fastboot

for p in $firmware_partitions; do
    flash "${p}_b" "${p}.img"
done

for p in $logical_partitions; do
    flash "${p}_b" "${p}.img"
done

# BACK TO BOOTLOADER (vbmeta)
$FASTBOOT reboot bootloader

for p in $vbmeta_partitions; do
    flash "${p}_b" "${p}.img"
done

#################################
# FINAL
#################################
$FASTBOOT --set-active=a
$FASTBOOT reboot

echo ""
echo "Your phone(1) is rebooting"
read -p "Press enter to continue"
