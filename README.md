# Nothing phone(1) tools

## Collection of useful scripts for the Nothing Phone(1)

I made these two scripts to make the life easier to who has a bricked NP(1) or if you simply want a clean install of the OS!

## DISCLAIMER:

**I am not responsible for any damage you made to your device. You have been warned.**

The `flash_all` script *should work* in most cases.

## OS support:

- macOS (x86 and arm64 support)
- GNU/Linux (x86 and arm64 support)
- Windows

## Prerequisites:

- **Latest** [android-platform-tools](https://developer.android.com/studio/releases/platform-tools) installed for your OS

- A Nothing phone(1) with unlocked bootloader running (or that was running) nothingOS <= 1.5.5

- `wget`, `curl`, `unzip` and `tar` installed (macOS/Linux only)

- Windows needs at least Windows 10 21H2 and powershell scripts enabled (Set-ExecutionPolicy Bypass)

## Usage (Windows):

- Download this repository

- Run the `download.ps1` script with powershell (Right click on the file > click "Run with Powershell")

- Now you can proceed with the flash running the `flash_all.bat` file (this will obviously delete all your personal data)

## Usage (macOS/Linux):

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

- and first of all download all the entire firmware that you need using

```
./download.sh
```

- if everything goes as expected, at the end your folder should be something like this:

<img width="1299" alt="Screenshot 2022-08-09 at 19 43 34" src="https://user-images.githubusercontent.com/55893559/183725466-d1e50e9b-f751-4027-82eb-ab72316f5260.png">

- Now you can proceed with the flash using (this will obviously delete all your personal data)

```
./flash_all.sh
```

Your Nothing Phone(1) will reboot and it (shoud) be alive!

## TIPS:

- After the flash procedure, it may help wipe and format data from recovery.

## TODO:

 - Fix super partition sporadics issues. On some cases it seems to "lock" the flashing directly to the dynamic partition (system, vendor etc...)

 - Maybe a GUI App to make easier for everyone

## Credits:

- [XDA Community (especially Sib64)](https://forum.xda-developers.com/t/phone-1-rom-ota-nothing-os-repo-of-nothing-os-update-04-08-2022.4464039/)
- ssut for [payload-dumper-go](https://github.com/ssut/payload-dumper-go)

## Links:

- [XDA Thread (for support)](https://forum.xda-developers.com/t/nothing-phone-1-flashing-utilities.4478457/)
- [Unbrick guide about the super partition](https://forum.xda-developers.com/t/how-to-unbrick-nothing-phone-1-fastboot-bootloop.4501439/)
