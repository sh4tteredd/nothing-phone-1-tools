#!/bin/bash

ERROR='\033[0;31m' #Red Color Code
INFO='\033[0;32m' #INFO Color Code
BOLD=$(tput bold) #Bold Font Code

check_adb() {
  if ! command -v ./platform-tools/fastboot > /dev/null; then
      echo "${RED}[*] Android Platform Tools are doesn't downloaded correctly!"
      echo "${RED}[*] In order to use this script please re-run the download script"
      exit
  fi
}

check_adb;

echo "${GREEN}${BOLD}[ Nothing phone(1) fastboot flash by @sh4tteredd ] \n"

echo "${ERROR}${BOLD}DON'T flash a nothingOS version lower than that one that's currently installed on the phone! \n"
echo "${GREEN}[*] In order to gather all the files that we need, consider to run my other script available on https://github.com/sh4tteredd/nothing-phone-1-tools \n"
echo "${GREEN}[*] Instead, if you already have the .img files, put all your files in a subfolder called 'images' to continue \n"
echo "${GREEN}[*] Now connect your phone in fastboot mode to the PC via USB, then press enter to continue"
read answer

#fastboot $* getvar product 2>&1 | grep "^product: *lahaina"
#if [ $? -ne 0 ] ; then echo "This script is only for nothing phone(1)"; exit 1; fi

if ./platform-tools/fastboot getvar product 2>&1 | grep -q "^product: *lahaina" || ./platform-tools/fastboot getvar product 2>&1 | grep -q "^product: *Spacewar"; then
  echo "${RED}[*] This script is only for nothing phone(1)"
  exit 1
fi

if [ ! -d "./images/" ]; then
  echo "${RED}[*] The images subfolder does not exists, check your files first!"
  exit 0
fi

./platform-tools/fastboot -w

if ./platform-tools/fastboot getvar current-slot 2>&1 | grep -q "^current-slot: *a"
  then
    slot=a
  else
    slot=b
fi

./platform-tools/fastboot --set-active=$slot

echo "${GREEN}${BOLD}Flashing A slot. Please wait... \n"

./platform-tools/fastboot reboot fastboot
./platform-tools/fastboot flash abl_$slot ./images/abl.img
./platform-tools/fastboot flash aop_$slot ./images/aop.img
./platform-tools/fastbootfastboot flash bluetooth_a ./images/bluetooth.img
./platform-tools/fastboot flash boot_$slot ./images/boot.img
./platform-tools/fastboot flash cpucp_$slot ./images/cpucp.img
./platform-tools/fastboot flash devcfg_$slot ./images/devcfg.img
./platform-tools/fastboot flash dsp_$slot ./images/dsp.img
./platform-tools/fastboot flash dtbo_$slot ./images/dtbo.img
./platform-tools/fastboot flash featenabler_$slot ./images/featenabler.img
./platform-tools/fastboot flash hyp_$slot ./images/hyp.img
./platform-tools/fastboot flash imagefv_$slot ./images/imagefv.img
./platform-tools/fastboot flash keymaster_$slot ./images/keymaster.img
./platform-tools/fastboot flash modem_$slot ./images/modem.img
./platform-tools/fastboot flash multiimgoem_$slot ./images/multiimgoem.img
./platform-tools/fastboot flash odm_$slot ./images/odm.img
./platform-tools/fastboot flash product_$slot ./images/product.img
./platform-tools/fastboot flash qupfw_$slot ./images/qupfw.img
./platform-tools/fastboot flash shrm_$slot ./images/shrm.img
./platform-tools/fastboot flash system_$slot ./images/system.img
./platform-tools/fastboot flash system_ext_$slot ./images/system_ext.img
./platform-tools/fastboot flash tz_$slot ./images/tz.img
./platform-tools/fastboot flash uefisecapp_$slot ./images/uefisecapp.img
./platform-tools/fastboot flash vbmeta_$slot ./images/vbmeta.img
./platform-tools/fastboot flash vbmeta_system_$slot ./images/vbmeta_system.img
./platform-tools/fastboot flash vendor_$slot ./images/vendor.img
./platform-tools/fastboot flash vendor_boot_$slot ./images/vendor_boot.img
./platform-tools/fastboot flash xbl_$slot ./images/xbl.img
./platform-tools/fastboot flash xbl_config_$slot ./images/xbl_config.img
./platform-tools/fastboot reboot bootloader

echo "${GREEN}${BOLD}Your phone(1) is rebooting"
read -p "Press enter to continue"