# openssl-lfcrypt
### How to use OpenSSL to encrypt large files using public-key encryption.
Quote from https://openssl-users.openssl.narkive.com/9PK71Fsu/the-problem-of-decrypting-big-files-encrypted-with-openssl-smime
> "The S/MIME encrypt streams with a low memory overhead while decrypt does not stream and needs the whole file in memory. It's a serious amount of effort to stream decrypt and so far there hasn't been enough interest to do that."

Now, while you can use streaming with encryption in the latest version of OpenSSL (OpenSSL 1.1.1u 30 May 2023 at the time of writing) you cannot then decrypt them. An option would be to use a memory mapped file, however you need to have that amount of memory available, and the whole thing becomes too complicated or simply unfeasible. 

### The solution available here
The proposed solution here consists in using a dynamically generated key to do the encryption, as suggested in this [Stackoverflow answer](https://stackoverflow.com/a/47504433/611526).

> Each time a new random symmetric key is generated, used, and then encrypted with the RSA cipher (public key). The ciphertext together with the encrypted symmetric key is transferred to the recipient. The recipient decrypts the symmetric key using his private key, and then uses the symmetric key to decrypt the message.

### How it works
We have two scripts, encrypt.sh and decrypt.sh. 

- encrypt.sh, given a public key and a file to encrypt, will generate a "$file.enc" and a "$file.key.enc", the first with the contents (encrypted using the self-generated symmetric key) and the second with the encrypted symmetric key (encrypted using the public key). 
- decrypt.sh, 





### Why some things are weird?
This is because these scripts are meant to be a direct replacement for the [mysqldump-secure](https://github.com/cytopia/mysqldump-secure/) project, but so far I was not able to contact the maintainer. That's the reason why we are using a specific format for the keys, and we are usinng the aes-256-cbc algo (which in modern SSL implementations generates, rightly so, a warning)
