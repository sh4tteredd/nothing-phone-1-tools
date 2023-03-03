#!/bin/bash

ERROR='\033[0;31m' # Red Color Code
INFO='\033[0;32m' # INFO Color Code

check() {
      if ! command -v $1 > /dev/null; then
      echo "${RED}[*] $1 is not installed!"
      echo "${RED}[*] In order to use this script please install ${INFO} $1 from your package manager"
      exit
  fi
}

clean() {
    echo "${INFO}[*] Cleaning..."
    rm -rf extracted*
    rm payload-dumper-go.tar.gz
    rm payload-dumper-go
    rm fw.zip
    rm payload.bin
    rm -rf platform-tools
}

download(){
read -p "${INFO}[*] Do you need the [G]lobal firmware or the [E]uropean firmware (G/E)? " ge 
case $ge in 
	G | g)  echo "${INFO}[*] Downloading the global firmware v1.1.7";
            echo "${INFO}[*] This may take a while depending on your internet speed \n";

            wget -q --show-progress -O fw.zip https://android.googleapis.com/packages/ota-api/package/254815bb72cdbddd5c9dd7cde6d10c95becc6542.zip;;
	E | e)  echo "${INFO}[*] Downloading the EU firmware v1.1.7";
            echo "${INFO}[*] This may take a while depending on your internet speed \n";

            wget -q --show-progress -O fw.zip https://android.googleapis.com/packages/ota-api/package/0e6855d19dbcdf328449e4d06386a6257bb1aadd.zip;;
    * )     echo "${ERROR}[*] Invalid input!";
		    exit 1;;
esac
}

echo "${INFO}[*] Nothing firmware downloader by @sh4ttered V1.1.7"
check wget
check tar
check unzip
rm -rf images/ #Clean from previous downloads

if [[ $(uname -m) == 'arm64' ]]; then #Check if arch is arm64
  arm="1"
fi
if [[ $(uname) == 'Linux' ]]; then #GNU/Linux
    os="linux"
elif [[ $(uname) == 'Darwin' ]]; then #MacOS
    os="darwin"
else
    echo "${INFO}[*] OS Unsupported"
    exit 1
fi

read -p "${INFO}[*] Have you already downloaded the firmware? (y/n)" choice
case "$choice" in
  y|Y ) echo "${INFO}[*] Skipping download";;
  n|N ) echo "${INFO}[*] Downloading firmware..."
        download;;
    * ) echo "${ERROR}[*] Invalid input!";
        exit 1;;
esac

#android platform tools downloader
if ! command -v fastboot > /dev/null | ! command -v adb > /dev/null; then
    wget -q -O platform-tools-latest-$os.zip https://dl.google.com/android/repository/platform-tools-latest-$os.zip
fi

if [[ $os -eq "linux" ]]; then #GNU/Linux
    if [[ $arm -eq 1 ]]; then #download arm64 version if needed
        wget -q -O payload-dumper-go.tar.gz https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_linux_arm64.tar.gz
    else
        wget -q -O payload-dumper-go.tar.gz https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_linux_amd64.tar.gz
    fi
elif [[ $os -eq "darwin" ]]; then #macOS
    if [[ $arm -eq 1 ]]; then #download arm64 version if needed
        wget -q -O payload-dumper-go.tar.gz https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_darwin_arm64.tar.gz
    else
        wget -q -O payload-dumper-go.tar.gz https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_darwin_amd64.tar.gz
    fi
fi

tar -zxf payload-dumper-go.tar.gz payload-dumper-go
if [ ! -f "fw.zip" ]; then
    echo "${ERROR}[*] fw.zip not found!"
    echo "${ERROR}[*] try to re-run the script"
    exit 1
fi

unzip -j fw.zip '*payload.bin*'
./payload-dumper-go payload.bin
echo "\n"
mkdir images
mv extracted*/* images/
clean;

unzip -j 'platform-tools-latest-'$os'.zip'
echo "${INFO}[*] Platform tools has been downloaded"

read -p "${INFO}[*] Do you want to flash your phone now? (y/N)? " yn 
if [[ $yn -eq y ]]; then 
    ./flash_all.sh
else
    exit 1
fi
