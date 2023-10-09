#!/bin/bash

echo && echo "CHECKSUM VERIFIER" && echo
printf "Enter checksum from website: " && read sha
printf "Enter File Path: " && read fpath

chk=$(sha256sum $fpath | cut -d " " -f 1 )
echo

printf "Stored HASH   : " && echo $sha
printf "Generated HASH: " && echo $chk
echo

if [ "$sha" == "$chk" ]
then
	echo "Checksums match !"
else
	echo "CRITICAL WARNING: Checksums don't match !!"
fi

#EOF#
