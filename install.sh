#!/usr/bin/env bash

set -e
set -u
PS4=" $ "
set -x

SD=vda

parted /dev/${SD} -- mklabel msdos
parted /dev/${SD} -- mkpart primary 1MiB -8GiB
parted /dev/${SD} -- mkpart primary linux-swap -8GiB 100%
mkfs.ext4 -L nixos /dev/${SD}1
mkswap -L swap /dev/${SD}2
mount /dev/disk/by-label/nixos /mnt
swapon /dev/${SD}2

mkdir -p /mnt/boot
mkdir -p /mnt/etc/nixos
curl -o /mnt/etc/nixos/configuration.nix http://duffman:8000/configuration.nix

nixos-generate-config --root /mnt

nixos-install
