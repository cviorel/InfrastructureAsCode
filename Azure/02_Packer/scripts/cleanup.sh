#!/bin/bash -eux

# Cleanup apt cache
apt-get -y autoremove --purge
apt-get -y clean
apt-get -y autoclean

echo "==> Cleaning up tmp"
rm -rf /tmp/*

exit 0
