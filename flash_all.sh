echo "nothing phone(1) fastboot flash v1.1.0EEA"

fastboot $* getvar product 2>&1 | grep "^product: *lahaina"
if [ $? -ne 0 ] ; then echo "This script is only for nothing phone(1)"; exit 1; fi
SCRIPT_PATH=$(dirname $0)

fastboot flash abl ${SCRIPT_PATH}/images/abl.img

fastboot flash aop ${SCRIPT_PATH}/images/aop.img

fastboot flash bluetooth ${SCRIPT_PATH}/images/bluetooth.img

fastboot flash boot ${SCRIPT_PATH}/images/boot.img

fastboot flash cpucp ${SCRIPT_PATH}/images/cpucp.img

fastboot flash devcfg ${SCRIPT_PATH}/images/devcfg.img

fastboot flash dsp ${SCRIPT_PATH}/images/dsp.img

fastboot flash dtbo ${SCRIPT_PATH}/images/dtbo.img

fastboot flash featenabler ${SCRIPT_PATH}/images/featenabler.img

fastboot flash hyp ${SCRIPT_PATH}/images/hyp.img

fastboot flash imagefv ${SCRIPT_PATH}/images/imagefv.img

fastboot flash keymaster ${SCRIPT_PATH}/images/keymaster.img

fastboot flash modem ${SCRIPT_PATH}/images/modem.img

fastboot flash multiimgoem ${SCRIPT_PATH}/images/multiimgoem.img

fastboot flash odm ${SCRIPT_PATH}/images/odm.img

fastboot flash product ${SCRIPT_PATH}/images/product.img

fastboot flash qupfw ${SCRIPT_PATH}/images/qupfw.img

fastboot flash shrm ${SCRIPT_PATH}/images/shrm.img

fastboot flash system ${SCRIPT_PATH}/images/system.img

fastboot flash system_ext ${SCRIPT_PATH}/images/system_ext.img

fastboot flash tz ${SCRIPT_PATH}/images/tz.img

fastboot flash uefisecapp ${SCRIPT_PATH}/images/uefisecapp.img

fastboot flash vbmeta ${SCRIPT_PATH}/images/vbmeta.img

fastboot flash vbmeta_system ${SCRIPT_PATH}/images/vbmeta_system.img

fastboot flash vendor ${SCRIPT_PATH}/images/vendor.img

fastboot flash vendor_boot ${SCRIPT_PATH}/images/vendor_boot.img

fastboot flash xbl ${SCRIPT_PATH}/images/xbl.img

fastboot flash xbl_config ${SCRIPT_PATH}/images/xbl_config.img

fastboot $* reboot

exit 0