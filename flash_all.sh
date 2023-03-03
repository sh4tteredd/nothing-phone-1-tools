#!/bin/bash

ERROR='\033[0;31m' #Red Color Code
INFO='\033[0;32m' #INFO Color Code
BOLD=$(tput bold) #Bold Font Code

if ! command -v fastboot > /dev/null; then
    APT=$APT
    else
    APT=fastboot
fi

echo "${GREEN}${BOLD}[ Nothing phone(1) fastboot flash by @sh4tteredd ] \n"

echo "${ERROR}${BOLD}DON'T flash a nothingOS version lower than that one that's currently installed on the phone! \n"
echo "${GREEN}[*] In order to gather all the files that we need, consider to run my other script available on https://github.com/sh4tteredd/nothing-phone-1-tools \n"
echo "${GREEN}[*] Instead, if you already have the .img files, put all your files in a subfolder called 'images' to continue \n"
echo "${GREEN}[*] Now connect your phone in fastboot mode to the PC via USB, then press enter to continue"
read answer

#fastboot $* getvar product 2>&1 | grep "^product: *lahaina"
#if [ $? -ne 0 ] ; then echo "This script is only for nothing phone(1)"; exit 1; fi

if $APT getvar product 2>&1 | grep -q "^product: *lahaina" || $APT getvar product 2>&1 | grep -q "^product: *Spacewar"; then
  echo "${RED}[*] This script is only for nothing phone(1)"
  exit 1
fi

if [ ! -d "./images/" ]; then
  echo "${RED}[*] The images subfolder does not exists, check your files first!"
  exit 0
fi

$APT -w

if $APT getvar current-slot 2>&1 | grep -q "^current-slot: *a"
  then
    slot=a
  else
    slot=b
fi

$APT --set-active=$slot

echo "${GREEN}${BOLD}Flashing A slot. Please wait... \n"

$APT reboot fastboot
$APT flash abl_$slot ./images/abl.img
$APT flash aop_$slot ./images/aop.img
$APT flash bluetooth_a ./images/bluetooth.img
$APT flash boot_$slot ./images/boot.img
$APT flash cpucp_$slot ./images/cpucp.img
$APT flash devcfg_$slot ./images/devcfg.img
$APT flash dsp_$slot ./images/dsp.img
$APT flash dtbo_$slot ./images/dtbo.img
$APT flash featenabler_$slot ./images/featenabler.img
$APT flash hyp_$slot ./images/hyp.img
$APT flash imagefv_$slot ./images/imagefv.img
$APT flash keymaster_$slot ./images/keymaster.img
$APT flash modem_$slot ./images/modem.img
$APT flash multiimgoem_$slot ./images/multiimgoem.img
$APT flash odm_$slot ./images/odm.img
$APT flash product_$slot ./images/product.img
$APT flash qupfw_$slot ./images/qupfw.img
$APT flash shrm_$slot ./images/shrm.img
$APT flash system_$slot ./images/system.img
$APT flash system_ext_$slot ./images/system_ext.img
$APT flash tz_$slot ./images/tz.img
$APT flash uefisecapp_$slot ./images/uefisecapp.img
$APT flash vbmeta_$slot ./images/vbmeta.img
$APT flash vbmeta_system_$slot ./images/vbmeta_system.img
$APT flash vendor_$slot ./images/vendor.img
$APT flash vendor_boot_$slot ./images/vendor_boot.img
$APT flash xbl_$slot ./images/xbl.img
$APT flash xbl_config_$slot ./images/xbl_config.img
$APT reboot bootloader

echo "${GREEN}${BOLD}Your phone(1) is rebooting"
read -p "Press enter to continue"