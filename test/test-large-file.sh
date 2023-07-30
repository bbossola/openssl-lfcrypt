#!/bin/bash

# Check if running in the right folder
if [ ! -f "../encrypt.sh" ]; then
  echo "Please run this in the test folder"
  exit 1
fi

# the script exits immediately on failure
set -e

# create a temporary folder to be cleaned on exit
clean_up() {
  test -d "$tmp_dir" && rm -fr "$tmp_dir"
}

tmp_dir=$( mktemp -d )
echo "Using temporary folder ${tmp_dir} (will be cleaned up)"
trap "clean_up $tmp_dir" EXIT

# define source and output files
source="${tmp_dir}/source.txt"
output="${tmp_dir}/output.txt"


# encrypt, decrypt and verify
echo "Generating 2GB file..."
dd if=/dev/urandom of=$source bs=2G count=1

echo "Encrypting 2GB file..."
../encrypt.sh "key.pub.pem" "$source"

echo "Decrypting 2GB file..."
../decrypt.sh "key.priv.pem" "$source.enc" "$output"

echo "Comparing files..."
if cmp -s $source $output; then
  echo "Success: the encryption worked as expected!"
  exit 0
else
  echo "Error: the files original ($source) and decrypted ($output) files are different :("
  exit 1
fi