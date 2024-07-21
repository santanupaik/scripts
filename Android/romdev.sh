#!/bin/bash

sudo apt update && sudo apt upgrade
sudo apt install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick lib32readline-dev lib32z1-dev libelf-dev liblz4-tool libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev llvm lib32ncurses5-dev libncurses5 libncurses5-dev python-is-python3 vim htop curl

wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip -j platform-tools-latest-linux.zip -d ~/.local/bin

curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.local/bin/repo
chmod a+x ~/.local/bin/repo

sudo chown $USER:$USER -R /mnt

cat >>~/.profile<< EOF
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export CCACHE_DIR=/mnt/ccache
EOF
source ~/.profile

mkdir -pv ~/android/lineage

read -p "Enter your Git Username: " userName
read -p "Enter your Git Email: " userEmail
git config --global user.email "$userEmail"
git config --global user.name "$userName"

git lfs install
ccache -M 50G

cd ~/android/lineage || exit
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs --depth=1 --groups=all,-darwin,-x86,-mips,-exynos5,mako
repo sync -c --no-clone-bundle --no-tags -j"$(nproc --all)"
repo sync -c --no-clone-bundle --no-tags -j"$(nproc --all)"
repo sync -c --no-clone-bundle --no-tags -j"$(nproc --all)"

echo "INFO: Reboot to apply the environment variables Permanently."
echo "INFO: Prepare device specific sourcecode and start building !"
