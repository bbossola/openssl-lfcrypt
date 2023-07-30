### Create public/private key
In order to initially generate the public/private keys, use the bundles shell script create-keypair.sh. This creates a 2048bit pair as follows:

```
openssl req -x509 -nodes -newkey rsa:2048 \
	-keyout key.priv.pem \
	-out key.pub.pem
```