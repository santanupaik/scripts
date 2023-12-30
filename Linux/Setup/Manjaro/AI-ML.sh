#!/bin/sh
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"
echo
echo "This script will install the necessary packages for basic python development on Manjaro."
sudo pacman-mirrors -f 2
sudo pacman -Sy --noconfirm python python-pip python-opencv python-matplotlib python-openai python-pandas python-openpyxl jupyter-notebook onlyoffice
echo
echo "Packages installed:"
echo "-------------------"
echo "|-> onlyoffice"
echo "|-> jupyter notebook"
echo "|-> python"
echo " |-> pip"
echo " |-> opencv"
echo " |-> matplotlib"
echo " |-> openai"
echo " |-> pandas"
echo " |-> openpyxl"
echo
echo "Setup Script by ITNerd1."
echo "You are now ready for developing in python :)"
echo
