#!/bin/bash
check_curl() {
  if ! command -v curl > /dev/null; then
      echo "curl is not installed!"
      echo "In order to use this script please install curl from your package manager"
      exit
  fi
}
check_tar() {
  if ! command -v tar > /dev/null; then
      echo "tar is not installed!"
      echo "In order to use this script please install tar from your package manager"
      exit
  fi
}
check_unzip() {
  if ! command -v unzip > /dev/null; then
      echo "unzip is not installed!"
      echo "In order to use this script please install unzip from your package manager"
      exit
  fi
}
check_wget() {
  if ! command -v wget > /dev/null; then
      echo "wget is not installed!"
      echo "In order to use this script please install wget from your package manager"
      exit
  fi
}
check_adb() {
  if ! command -v fastboot > /dev/null; then
      echo "Android Platform Tools are not installed!"
      echo "In order to use this script please install the android platform tools from your package manager"
      exit
  fi
}
clean() {
    echo "cleaning..."
    rm -rf extracted*
    rm -rf META-INF
    rm payload_properties.txt
    rm payload-dumper-go.tar.gz
    rm payload-dumper-go
    rm fw.zip
    rm payload.bin
    rm apex_info.pb
    rm care_map.pb
}
echo "Nothing firmware downloader by @sh4ttered V1.1.0"
check_curl;
check_wget;
check_adb;
check_tar;
check_unzip;

rm -rf images/ #clean from previous downloads
if [ -f "payload-dumper-go.tar.gz" ]; then
    rm payload-dumper-go.tar.gz #clean from previous downloads
fi
if [[ $(uname -m) == 'arm64' ]]; then #check if arch is arm64
  arm="1"
fi
if [[ $(uname) == 'Linux' ]]; then #GNU/Linux
    linux="1"
elif [[ $(uname) == 'Darwin' ]]; then #macOS
    mac="1"
fi

echo "now you have to download the firmware from the androidfilehost website"
read -p "Do you need the [G]lobal firmware or the [E]uropean firmware (G/E)? " ge 
case $ge in 
	G | g) echo "Downloading the global firmware 1.1.0";
            echo "This may take a while depending on your internet speed";
        if [[ $mac -eq "1" ]] ; then open https://androidfilehost.com/?fid=15664248565197192084 ; else xdg-open https://androidfilehost.com/?fid=15664248565197192084; fi
        echo " ";;
	E | e) echo "Downloading the EU firmware 1.1.0";
        echo "This may take a while depending on your internet speed";
        if [[ $mac -eq "1" ]] ; then open https://androidfilehost.com/?fid=15664248565197192093 ; else xdg-open https://androidfilehost.com/?fid=15664248565197192093; fi
        echo " ";;
    * ) echo "Invalid input!";
		exit 1;;
esac

read -p "When the download finishes, paste the path of the file here (or simply drag and drop): " r1

if [[ $linux -eq "1" ]]; then #GNU/Linux
    if [[ $arm -eq 1 ]]; then #download arm64 version if needed
        wget -q https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_linux_arm64.tar.gz
    else
        wget -q https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_linux_amd64.tar.gz
    fi
elif [[ $mac -eq "1" ]]; then #macOS
    if [[ $arm -eq 1 ]]; then #download arm64 version if needed
        wget -q https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_darwin_arm64.tar.gz
    else
        wget -q https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_darwin_amd64.tar.gz
    fi
fi
mv $r1 ./fw.zip
mv payload-dumper-go*.tar.gz payload-dumper-go.tar.gz
tar -zxf payload-dumper-go.tar.gz payload-dumper-go
unzip -q fw.zip
./payload-dumper-go payload.bin
echo " "
mkdir images
mv extracted*/* images/
clean;
