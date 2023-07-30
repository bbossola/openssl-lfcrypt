### Create public/private key
In order to initially generate the public/private keys, use the bundles shell script create-keypair.sh. This creates a 2048bit pair as follows:

```
openssl req -x509 -nodes -newkey rsa:2048 \
	-keyout key.priv.pem \
	-out key.pub.pem
```

This is required to maintain compatibility with the project where these script are meant to be a direct replacement for,  the [mysqldump-secure](https://github.com/cytopia/mysqldump-secure/).


### Simple tests
Two automated tests are available: one that tries a small file and another that tries a large file. 
They both has the same structure:
- a sample file is created 
- it's encrypted
- it's decripted
- the original and the decrypted are compared
