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

- encrypt.sh, given a public key and a file to encrypt, will generate a ".enc" and a ".enc.key", the first with the encrypted contents and the second with the encrypted key. 
- decrypt.sh, 



