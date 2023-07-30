#!/bin/sh
set -e 

usage() {
	echo "Usage: ${0} pubkey inputfile"
}

if [ $# -ne 2 ]; then
	echo "Invalid number of arguments (received $# arguments)"
	usage
	exit 1
fi

if [ ! -f "${1}" ]; then
	echo "pubkey ${1} not found,"
	usage
	exit 1
fi

if [ ! -f "${2}" ]; then
	echo "inputfile ${2} not found,"
	usage
	exit 1
fi

keyfile=${2}.key

# generate a symmetric key to encrypt the large file
openssl11 rand -base64 32 > $keyfile

# encrypt the large file using the symmetric key
openssl11 enc -aes-256-cbc -salt -in "${2}" -out "${2}.enc" -pass file:$keyfile

# encrypt the symmetric key so you can safely send it 
openssl11 smime -encrypt -binary -aes256 -in $keyfile -out $keyfile.enc -outform DER "${1}"

# destroy the un-encrypted symmetric key so nobody finds it
shred -u $keyfile

if [ $? -ne 0 ]; then
	exit 1
else
	exit 0
fi
