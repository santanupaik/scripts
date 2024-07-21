#!/bin/bash

wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip platform-tools-latest-linux.zip -d ~

curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

sudo apt update && sudo apt upgrade
sudo apt install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick lib32readline-dev lib32z1-dev libelf-dev liblz4-tool libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev llvm lib32ncurses5-dev libncurses5 libncurses5-dev python-is-python3

cat >>~/.bashrc<< EOF
# add Android SDK platform tools to path
if [ -d "$HOME/platform-tools" ] ; then
    PATH="$HOME/platform-tools:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export CCACHE_DIR=/mnt/ccache
EOF

mkdir -pv ~/bin
mkdir -pv ~/android/lineage

read -pr "Enter your Git Username: " userName
read -pr "Enter your Git Email: " userEmail
git config --global user.email "$userEmail"
git config --global user.name "$userName"

git lfs install
ccache -M 50G

cd ~/android/lineage || exit
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs --depth=1 --groups=all,-darwin,-x86,-mips,-exynos5,mako
repo sync -c --no-clone-bundle --no-tags -j"$(nproc --all)"
repo sync -c --no-clone-bundle --no-tags -j"$(nproc --all)"
repo sync -c --no-clone-bundle --no-tags -j"$(nproc --all)"

echo "Now prepare Device Specific sourcecode and start building !"
