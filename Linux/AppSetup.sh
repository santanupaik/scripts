#!/bin/bash

# Setting Colour Options
bold=$(tput bold)
r=`tput setaf 1`
g=`tput setaf 2`
b=`tput setaf 4`
y=`tput setaf 3`
re=`tput sgr0`

# Intro Text
echo
echo "${bold}### ${g}ANDROID ${b}APP ${y}SETUP ${re}${bold}###"
echo
echo "${b}Starting Setup.....${re}"
echo

# Setting Variables for APK Downloads.
echo "${bold}${y}Getting APKs...${re}"
API="https://f-droid.org/api/v1/packages/"
ALFD="https://f-droid.org/F-Droid.apk"
GAL="https://f-droid.org/repo/"
MF="me.zhanghai.android.files"
SK="rkr.simplekeyboard.inputmethod"
US="_"

# Getting APK versions using the F-Droid API
VCMF=$(awk '{ sub(/.*"suggestedVersionCode":/, ""); sub(/,"packages".*/, ""); print }' <<< $(curl -s $API$MF ))
VCSK=$(awk '{ sub(/.*"suggestedVersionCode":/, ""); sub(/,"packages".*/, ""); print }' <<< $(curl -s $API$SK))
echo

# Fetching the F-Droid GPG Key
echo "${bold}${g}Fetching the F-Droid GPG Key...${re}"
gpg -q --keyserver keyserver.ubuntu.com --recv-key 37D2C98789D8311948394E3E41E7044E1DBA2E89
echo

# Downloading F-Droid and other specified APK files
echo "${bold}${g}Downloading F-Droid...${re}"
wget -q $ALFD && wget -q $ALFD.asc
echo "${bold}${g}Downloading Material Files...${re}"
wget -q $GAL$MF$US$VCMF.apk && wget -q $GAL$MF$US$VCMF.apk.asc
echo "${bold}${g}Downloading Simple Keyboard...${re}"
wget -q $GAL$SK$US$VCSK.apk && wget -q $GAL$SK$US$VCSK.apk.asc
echo

# Verifying F-Droid and other specified APK files
echo "${bold}${b}Verifying F-Droid APK...${re}"
gpg --verify F-Droid.apk.asc F-Droid.apk
echo
echo "${bold}${b}Verifying Material Files APK...${re}"
gpg --verify $MF$US$VCMF.apk.asc $MF$US$VCMF.apk
echo
echo "${bold}${b}Verifying Simple Keyboard APK...${re}"
gpg --verify $SK$US$VCSK.apk.asc $SK$US$VCSK.apk
echo

# Starting ADB server
adb start-server
adb devices

# Begin Debloating
echo "${bold}${r}Debloating.........${re}"
printf "Removing Google Calendar...             "
adb shell pm uninstall -k --user 0 com.google.android.calendar
printf "Removing Chrome...                      "
adb shell pm uninstall -k --user 0 com.android.chrome
printf "Removing Google Files...                "
adb shell pm uninstall -k --user 0 com.google.android.apps.nbu.files
printf "Removing Digital Wellbeing...           "
adb shell pm uninstall -k --user 0 com.google.android.apps.wellbeing
printf "Removing Google Search...               "
adb shell pm uninstall -k --user 0 com.google.android.googlequicksearchbox
printf "Removing Google Play Store...           "
adb shell pm uninstall -k --user 0 com.android.vending
printf "Removing Google Photos...               "
adb shell pm uninstall -k --user 0 com.google.android.apps.photos
printf "Removing Sim Toolkit...                 "
adb shell pm uninstall -k --user 0 com.android.stk
printf "Removing Android System Intelligence... "
adb shell pm uninstall -k --user 0 com.google.android.as
printf "Removing Gamespace...                   "
adb shell pm uninstall -k --user 0 io.chaldeaprjkt.gamespace
printf "Removing Google location History...     "
adb shell pm uninstall -k --user 0 com.google.android.gms.location.history
printf "Removing Google Text to Speech...       "
adb shell pm uninstall -k --user 0 com.google.android.tts
printf "Removing Android Auto...                "
adb shell pm uninstall -k --user 0 com.google.android.projection.gearhead
printf "Removing Google Calculator...           "
adb shell pm uninstall -k --user 0 com.google.android.calculator
printf "Removing Google Keyboard...             "
adb shell pm uninstall -k --user 0 com.google.android.inputmethod.latin
printf "Removing Vi Music...                    "
adb shell pm uninstall -k --user 0 it.vfsfitvnm.vimusic
printf "Removing Viper4Android...               "
adb shell pm uninstall -k --user 0 com.wstxda.viper4android
echo

# Installing the previously Downloaded APKs
echo "${bold}${g}Installing Apps.........${re}"
pwd=$(pwd)
apkpath="$pwd/*.apk"
for apk in $apkpath
do
  adb install $apk
done

# Rebooting the Device
echo
sleep 5; adb reboot
echo "${bold}${b}Rebooting Device........."

# Exit Text
echo
echo "${y}Script Succeeded !!${re}"
echo
# EOF
