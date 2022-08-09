#!/bin/bash
check_curl() {
  if ! command -v curl > /dev/null; then
      echo "curl is not installed!"
      echo "In order to use this script please install wget from your package manager"
      exit
  fi
}
clean() {
    echo "cleaning..."
    rm -rf extracted*
    rm LICENSE
    rm -rf META-INF
    rm payload_properties.txt
    rm payload-dumper-go
    rm fw.zip
    rm payload.bin
    rm README.md
    rm apex_info.pb
    rm care_map.pb
}
check_wget() {
  if ! command -v curl > /dev/null; then
      echo "wget is not installed!"
      echo "In order to use this script please install wget from your package manager"
      exit
  fi
}
echo "Nothing firmware downloader by @sh4ttered V1.1.0"
check_curl;
check_wget;

rm -rf images/ #clean from previous downloads
FILE=payload-dumper-go.tar.gz
if [ -f "$FILE" ]; then
    rm payload-dumper-go.tar.gz #clean from previous downloads
fi

if [[ $(uname -m) == 'arm64' ]]; then #check if arch is arm64
  arm="1"
fi

read -p "Do you need the [G]lobal firmware or the [E]uropean firmware (G/E)" ge 
case $ge in 
	G ) echo "Downloading the global firmware 1.1.0";
        echo "This may take a way depending on your internet speed";
        echo " ";
        curl https://mde1.androidfilehost.com/dl/PfKhvf7Ic7YYylFx2wkH8Q/1660138643/15664248565197192084/Global_Nothing_OS_1.1.0_Update.zip --output fw.zip;;
	E ) echo "Downloading the EU firmware 1.1.0";
        echo "This may take a way depending on your internet speed";
        echo " ";
        curl https://mde1.androidfilehost.com/dl/yrsVRoAumRznxsu7QIBTow/1660130195/15664248565197192093/Europe_Nothing_OS_1.1.0_Update.zip --output fw.zip;;
    * ) echo invalid response;
		exit 1;;
esac
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then #GNU/Linux
    if [[ $arm -eq 1 ]]; then #download arm64 version if needed
        wget -q https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_linux_arm64.tar.gz
    else
        wget -q https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_linux_amd64.tar.gz
    fi
elif [[ "$unamestr" == 'Darwin' ]]; then #macOS
    if [[ $arm -eq 1 ]]; then #download arm64 version if needed
        wget -q https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_darwin_arm64.tar.gz
    else
        wget -q https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_darwin_amd64.tar.gz
    fi
fi
mv payload-dumper-go*.tar.gz payload-dumper-go.tar.gz
tar -zxf payload-dumper-go.tar.gz
rm payload-dumper-go.tar.gz
unzip -q fw.zip
./payload-dumper-go payload.bin
echo " "
mkdir images
mv extracted*/* images/
clean;