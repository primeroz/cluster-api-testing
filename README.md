
## SOPS

* sops --decrypt secrets.enc.json > /tmp/secrets.json
* vim /tmp/secrets.json
* sops --encrypt --pgp 0x571CABDF5DF83422 /tmp/secrets.json > secrets.enc.json
* sops exec-env secrets.json 'make test-secrets'
