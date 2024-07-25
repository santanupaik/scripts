#!/bin/sh

printf "\e[38;5;208m%s\e[0m\n\n" "Openwrt DNS over TLS Setup v1.0"
printf "Updating Openwrt Package Lists"
opkg update > /dev/null
printf "\e[38;5;69m%s\e[0m\n" "    DONE"

printf "Installing Stubby"
opkg install stubby > /dev/null
printf "\e[38;5;69m%s\e[0m\n" "                 DONE"

printf "Stopping Dnsmasq"
service dnsmasq stop
printf "\e[38;5;69m%s\e[0m\n" "                  DONE"

printf "Configuring Stubby"
uci set dhcp.@dnsmasq[0].noresolv="1"
uci -q delete dhcp.@dnsmasq[0].server
uci -q get stubby.global.listen_address \
| sed -e "s/\s/\n/g;s/@/#/g" \
| while read -r STUBBY_SERV
do uci add_list dhcp.@dnsmasq[0].server="${STUBBY_SERV}"
done
uci set dhcp.@dnsmasq[0].localuse="0"
printf "\e[38;5;69m%s\e[0m\n" "                DONE"

printf "Saving configuration"
uci commit dhcp
printf "\e[38;5;69m%s\e[0m\n" "              DONE"

printf "Starting Dnsmasq"
service dnsmasq start > /dev/null 2>&1
printf "\e[38;5;69m%s\e[0m\n" "                  DONE"

printf "\n\e[38;5;46m%s\e[0m\n" "Setup Complete"
