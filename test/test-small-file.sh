#!/bin/sh
source="/tmp/source.txt"
output="/tmp/output.txt"

echo "Generating small file..."
echo "Hello, OpenSSL pub-key encryption." > $source

echo "Encrypting small file..."
../encrypt.sh "key.pub.pem" "$source"

echo "Decrypting small file..."
../decrypt.sh "key.priv.pem" "$source.enc" "$output"

if cmp -s $source $output; then
  echo "Success: the encryption worked as expected!"
  exit 0
else
  echo "Error: the files original ($source) and decrypted ($output) files are different :("
  exit 1
fi