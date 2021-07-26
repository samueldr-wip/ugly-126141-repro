#!/usr/bin/env nix-shell
#! nix-shell -p qemu -i bash

set -e
set -u
PS4=" $ "
set -x

rm disk.img
qemu-img create -f qcow2 disk.img 10G

QEMU=(
  --enable-kvm
  -device "e1000,netdev=net0"
  -netdev "user,id=net0"
  #-display curses
  -display none
  -serial mon:stdio
  -drive "file=disk.img,if=virtio"
  -m 4096
  -cdrom ./nixos-minimal-21.05.1669.973910f5c31-x86_64-linux.iso
  #-cdrom "/nix/store/14lkkfc928z16jsz75ff1kkvf1kdqla7-nixos-minimal-21.05beta-160507.gfedcba-x86_64-linux.iso/iso/nixos-minimal-21.05beta-160507.gfedcba-x86_64-linux.iso"
)

exec qemu-system-x86_64 "${QEMU[@]}"

# To run in the VM
cat <<EOF
#
# If running with -display curses
#  In early boot, in 800x600 graphical mode, press [down], [enter]
#  This will boot in nomodeset.
#
# If running with -display none and -serial mon:stdio
#  Choose boot option with console=ttyS0
#
# Then run the following commands in the qemu instance
sudo -i
curl -O http://duffman:8000/install.sh
bash install.sh
EOF
