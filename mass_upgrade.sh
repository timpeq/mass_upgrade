#!/bin/bash

# This is a rather blunt tool to upgrade this host and running LXD containers.  
# The tool assumes Ubuntu (but should work on any Debian host/container using `apt`)
# You should keep focus while upgrade proceeds because some updates may require user interraction.

container_list="$(lxc list -c ns | awk '!/NAME/{ if ( $4 == "RUNNING" ) print $2}')"

if [[ $1 != -y ]]; then
  echo "This script will upgrade this host ($HOSTNAME) and the following LXD containers:"
  printf "  "
  for i in $container_list
  do
    printf "$i "
  done
  printf "\n"
  printf "Continue? [y/n]: "
  read -n 1 continue_response
  printf "\n"
  if [[ $continue_response == y ]]; then
    echo "..."
  else
    echo "Exiting..."
    exit 1
  fi

fi

echo "Upgrading $HOSTNAME"
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

for i in $container_list
do
  echo "Upgrading container $i"
  lxc exec $i -- apt update
  lxc exec $i -- apt upgrade -y
  lxc exec $i -- apt autoremove -y

  # Container specific commands

  if [[ $i == pihole ]]; then
    echo "Running pihole upgrade script"
    lxc exec pihole -- pihole -up
  fi

  if [[ $i == apache ]]; then
    echo "Restarting apache service"
    lxc exec apache -- service apache2 restart
  fi

  if [[ $i == nextcloud ]]; then
    echo "Upgrading Nextcloud"
    lxc exec nextcloud -- /root/upgrade_nextcloud.sh
  fi

done
