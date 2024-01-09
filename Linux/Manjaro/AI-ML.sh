#!/bin/sh
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"
echo
echo "This script will install the necessary packages for basic python development on Manjaro."
sudo pacman -Sy --noconfirm python-pip python-opencv python-matplotlib python-openai python-pandas python-openpyxl python-numpy python-seaborn jupyter-notebook
echo
echo "Packages installed:"
echo "─┬─────────────────"
echo " ├─> pip"
echo " ├─> opencv"
echo " ├─> matplotlib"
echo " ├─> openai"
echo " ├─> pandas"
echo " ├─> openpyxl"
echo " ├─> numpy"
echo " ├─> seaborn"
echo " └─> jupyter-notebook"
echo
echo "Setup Script by ITNerd1."
echo "You are now ready for developing in python :)"
echo
