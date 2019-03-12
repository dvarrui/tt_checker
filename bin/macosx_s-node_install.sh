#!/bin/bash
# MacOSX S-Node Installation
# version: 20190312

[ $(whoami) != root ] && echo "[ERROR] Please, run as root" && exit 1

echo "[0/2.INFO] MacOSX S-NODE installation"

echo "[1/2.INFO] Enabling SSH server..."
systemsetup -setremotelogin on

echo "[2/2.INFO] Finish!"