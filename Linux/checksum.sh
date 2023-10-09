#!/bin/bash

bold=$(tput bold)
r=`tput setaf 1`
g=`tput setaf 2`
b=`tput setaf 4`
y=`tput setaf 3`
re=`tput sgr0`

echo && echo "${bold}${b}CHECKSUM VERIFIER${re}" && echo
printf "${bold}Enter checksum from website: ${re}" && read sha
printf "${bold}Enter File Path: ${re}" && read fpath

chk=$(sha256sum $fpath | cut -d " " -f 1 )
echo

printf "${bold}Stored HASH   : " && echo ${y}$sha${re}
printf "${bold}Generated HASH: " && echo ${y}$chk${re}
echo

if [ "$sha" == "$chk" ]
then
	echo "${bold}${g}SUCCESS: Checksums match !${re}"
else
	echo "${bold}${r}CRITICAL WARNING: Checksums don't match !!${re}"
fi

#EOF#
