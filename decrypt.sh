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
	*.enc)	
		OUT_FILENAME="$(basename "${2}" .enc)"
		tmp="$2"
		keyfile="${tmp%.*}.key"
		;;
	*)		
		OUT_FILENAME="${2}.decrypted"
		keyfile="${2}".key
		;;
esac

if [ $# -eq 3 ]; then
	OUT_FILENAME=${3}
	echo "Using output file $OUT_FILENAME"
fi

echo "Using key file ${keyfile}"
if [ ! -f "$keyfile.enc" ]; then
	echo "encrypted key file $keyfile.enc not found,"
	usage
	exit 1
fi


# decrypt the symmetric key with the private key
openssl smime -decrypt -in $keyfile.enc -binary -inform DEM -inkey "${1}" -out $keyfile

# decrypt the large file usign the simmetric key
openssl enc -d -aes-256-cbc -in "${2}" -out "${OUT_FILENAME}" -pass file:$keyfile

if [ $? -ne 0 ]; then
	exit 1
else
	exit 0
fi

