#!/bin/bash
check() {
      if ! command -v $1 > /dev/null; then
      echo "$1 is not installed!"
      echo "In order to use this script please install $1 from your package manager"
      exit
  fi
}

clean() {
    echo "Cleaning..."
    rm -rf extracted*
    rm payload-dumper-go.tar.gz
    rm payload-dumper-go
    rm fw.zip
    rm payload.bin
}

download(){

read -p "Do you need the [G]lobal firmware or the [E]uropean firmware (G/E)? " ge 
case $ge in 
	G | g)  echo "Downloading the global firmware v1.1.6";
            echo "This may take a while depending on your internet speed";
            echo " ";
            wget -q --show-progress -O fw.zip https://android.googleapis.com/packages/ota-api/package/99a4c814632616b365017129fa9f7e9e0080fb59.zip;;
	E | e)  echo "Downloading the EU firmware v1.1.7";
            echo "This may take a while depending on your internet speed";
            echo " ";
            wget -q --show-progress -O fw.zip https://android.googleapis.com/packages/ota-api/package/0e6855d19dbcdf328449e4d06386a6257bb1aadd.zip;;
    * )     echo "Invalid input!";
		    exit 1;;
esac


    
}
echo "Nothing firmware downloader by @sh4ttered V1.1.6 (1.1.7 for EU)"
check wget
check tar
check unzip
rm -rf images/ #clean from previous downloads

if [[ $(uname -m) == 'arm64' ]]; then #check if arch is arm64
  arm="1"
fi
if [[ $(uname) == 'Linux' ]]; then #GNU/Linux
    linux="1"
elif [[ $(uname) == 'Darwin' ]]; then #macOS
    mac="1"
else
    echo "OS Unsupported"
    exit 1
fi

read -p "Have you already downloaded the firmware? (y/n)" choice
case "$choice" in
  y|Y ) echo "Skipping download";;
  n|N ) echo "Downloading firmware..."
        download;;
    * ) echo "Invalid input!";
        exit 1;;
esac

if [[ $linux -eq "1" ]]; then #GNU/Linux
    if [[ $arm -eq 1 ]]; then #download arm64 version if needed
        wget -q -O payload-dumper-go.tar.gz https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_linux_arm64.tar.gz
    else
        wget -q -O payload-dumper-go.tar.gz https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_linux_amd64.tar.gz
    fi
elif [[ $mac -eq "1" ]]; then #macOS
    if [[ $arm -eq 1 ]]; then #download arm64 version if needed
        wget -q -O payload-dumper-go.tar.gz https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_darwin_arm64.tar.gz
    else
        wget -q -O payload-dumper-go.tar.gz https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_darwin_amd64.tar.gz
    fi
fi

tar -zxf payload-dumper-go.tar.gz payload-dumper-go
if [ ! -f "fw.zip" ]; then
    echo "fw.zip not found!"
    echo "try to re-run the script"
    exit 1
fi
unzip -j fw.zip '*payload.bin*'
./payload-dumper-go payload.bin
echo " "
mkdir images
mv extracted*/* images/
clean;
read -p "Do you want to flash your phone now? (y/N)? " yn 
if [[ $yn -eq y ]]; then 
    ./flash_all.sh
else
    exit 1
fi
