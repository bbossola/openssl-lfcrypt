#!/bin/sh

usage() {
	echo "Usage: ${0} privkey encryptedfile [dencryptedfile]"
}


if [ "$#" -lt 2 ]; then
	echo "Invalid number of arguments."
	usage
	exit 1
fi
if [ ! -f "${1}" ]; then
	echo "privkey ${1} not found,"
	usage
	exit 1
fi
if [ ! -f "${2}" ]; then
	echo "encryptedfile ${2} not found,"
	usage
	exit 1
fi

case "${2}" in
	*.enc)	OUT_FILENAME="$(basename "${2}" .enc)";;
	*)		OUT_FILENAME="${2}.decrypted"
esac

if [ $# -eq 3 ]; then
	OUT_FILENAME=${3}
	echo "Using output file $OUT_FILENAME"
fi

openssl smime -decrypt \
	-in "${2}" \
	-stream -binary -inform DEM \
	-inkey "${1}" \
	-out "${OUT_FILENAME}"

if [ $? -ne 0 ]; then
	exit 1
else
	exit 0
fi

