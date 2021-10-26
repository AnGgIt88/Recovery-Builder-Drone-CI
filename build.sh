#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

# Function to show an informational message
msg() {
    echo -e "\e[1;32m$*\e[0m"
}

err() {
    echo -e "\e[1;41m$*\e[0m"
}

DATE=$(date +"%F-%S")
START=$(date +"%s")

# Inlined function to post a message
export BOT_MSG_URL="https://api.telegram.org/bot$TG_TOKEN/sendMessage"
tg_post_msg() {
	curl -s -X POST "$BOT_MSG_URL" -d chat_id="$TG_CHAT_ID" \
	-d "disable_web_page_preview=true" \
	-d "parse_mode=html" \
	-d text="$1"

}

tg_post_build() {
	curl --progress-bar -F document=@"$1" "$BOT_MSG_URL" \
	-F chat_id="$TG_CHAT_ID"  \
	-F "disable_web_page_preview=true" \
	-F "parse_mode=html" \
	-F caption="$3"
}

# Send a notificaton to TG
tg_post_msg "<b>Test Building XiaomiParts Apps...</b>%0A<b>DATE : </b><code>$DATE</code>%0A"
mkdir ~/Projects && cd ~/Projects
git config --global user.email jarbull87@gmail.com
git config --global user.name AnGgIt88
apt-get -y update && apt-get -y upgrade
apt-get install openssh-server -y
apt-get update --fix-missing

repo init --depth=1 -u https://gitlab.com/OrangeFox/Manifest.git -b fox_9.0
git clone https://github.com/AnGgIt88/xd_device_xiaomi_rosy --depth=1 -b eleven device/xiaomi/rosy
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc)
export ALLOW_MISSING_DEPENDENCIES=true
. build/envsetup.sh
mmma /device/xiaomi/rosy/XiaomiParts

# Push Rom to channel
    cd out/target/product/rosy/system/priv-app/XiaomiParts
    zip -r9 XiaomiParts.zip *
    ZIP=$(echo *.zip)
    curl -F document=@$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 
