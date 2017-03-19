# Alter a Raspberry Pi Stock Image before Burning to SD Card
## Why?
* Nice to have a customised image which will automatically connect to wifi, especially when you want to use the pi in 'headless mode'.
* Also includes customisation to allow connection to an Android Device. The screen of the android device can be used as a display for the Raspberry Pi.

## How?
1. Download the script to a folder on your hard drive (only tested on Ubuntu Linux).
2. Run the script, passing the wifi username and password:
> ./add_wifi_creds.sh <ssid> <password>
3. The image will be downloaded and altered to suit

## Notes
* The image name is hardcoded, so will have to be changed when a new one becomes available. I can probably automate this with a bit more work.
* This is a bash script, which I don't know that well, but I wrote this as a learning excercise.


