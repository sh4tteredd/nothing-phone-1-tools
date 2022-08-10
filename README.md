# Nothing phone(1) tools

## Collection of useful scripts for the Nothing Phone(1)

I made these two script to make the life easier to who has a bricked NP(1) or if you simply want a clean install of the OS!

## DISCLAIMER:

**I am not responsible for any damage you made to your device. You have been warned**

## OS support:

- macOS (x86 and arm64 support)
- GNU/Linux (x86 and arm64 support)
- Windows support is arriving soon

## Prerequisites:

- [android-platform-tools](https://developer.android.com/studio/releases/platform-tools) installed for your OS

- A Nothing phone(1) with unlocked bootloader

- `curl`, `wget`, `unzip` and `tar` installed

## Usage:

- clone this repo using

```
git clone https://github.com/sh4tteredd/nothing-phone-1-tools.git
```

- cd into the downloaded folder

```
cd nothing-phone-1-tools/
```

- give execution permissions to all the scripts

```
chmod +x *
```

- and first of all download all the the entire firmware that you need using

```
./download.sh
```

- if everything goes as expected, at the end your folder should be something like this:

<img width="1299" alt="Screenshot 2022-08-09 at 19 43 34" src="https://user-images.githubusercontent.com/55893559/183725466-d1e50e9b-f751-4027-82eb-ab72316f5260.png">

- Now you can proceed with the flash using (this will obviously delete all your personal data)

```
./flash-all.sh
```

Your Nothing Phone(1) will reboot and it (shoud) be alive!

## TODO:

It would be nice to download the firmware directly from Nothing's servers (actually is used an **original** version uploaded by the community)

## Credits:

- [XDA Community (especially Sib64)](https://forum.xda-developers.com/t/phone-1-rom-ota-nothing-os-repo-of-nothing-os-update-04-08-2022.4464039/)
- ssut for [payload-dumper-go](https://github.com/ssut/payload-dumper-go)
