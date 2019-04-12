#!/usr/bin/env bash

if ! which qrencode > /dev/null 2>&1
then
    echo "Please install qrencode package"
    exit 1
fi

read -p "Enter server hostname: " HOSTNAME
read -p "Enter SSH user: " USER

echo "hex key:"
HEX=$(head -10 /dev/urandom | sha512sum | cut -b 1-30)
echo
echo ${HEX}
echo
echo "hex key for ansible inventory:"
echo
echo ${HEX} | ansible-vault encrypt
echo
echo "base32 for 2FA app:"
echo
HEX32=$(echo ${HEX} | xxd -r -p | base32 )
echo ${HEX32}
echo
qrencode "otpauth://totp/${USER}@${HOSTNAME}?secret=${HEX32}" -o ${HOSTNAME}.png -s15
echo "QRCode generated"
