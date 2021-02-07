# LabCA
The main goal of this repository is to get an easy way to create your own RSA certificate CA suite for using it in your lab environment.

## Installation

```bash
git clone https://github.com/DariuSGB/LabCA.git
cd LabCA
chmod +x $(ls | grep -v README)
```

## Description

| Script | Description |
| --- | --- |
| [`create_root_ca.sh`](##-create-ca) | generate a CA certificate and store it in **./ca/** |
| `create_int_ca.sh` | generate an intermediate CA signed by the root CA and store it in **./ca/** |
| `gen_cert.sh` | generate an certificate signed by the defined CA and store it in **./cert/** |
| `gen_ocsp.sh` | generate an OCSP certificate for signing OCSP requests and store it in **./ca/** |
| `gen_crl.sh` | generate a CRL certificate and store it in **./ca/** |
| `revoke_sn.sh` | revoke a certificate base on serial number |
| `gen_pkcs12.sh` | generate a PKCS#12 certificate from a PEM certificate provided |
| `ocsp_responder.sh` | generate a OCSP responder for listening requests on port 8080 |
| `clear_env.sh` | clear all folders and certs |

## Create CA

This script is used to generate the root CA certificate.

This certificate is created with the next x509 extensions:
- Basic Constraints: CA:TRUE
- Subject Key Identifier
- Authority Key Identifier

### Usage

```bash
./create_root_ca.sh <ca_name>
```

### Example

```
./create_root_ca.sh mylabCA
...
Enter pass phrase for /home/user/LabCA/ca/mylabCA.key:****
Verifying - Enter pass phrase for /home/user/LabCA/ca/mylabCA.key:****
Enter pass phrase for /home/user/LabCA/ca/mylabCA.key:****
...
```

### Folders

| Folder | Description |
| --- | --- |
| `ca` | Where CA certificates are stored (CA, CRL, OCSP) |
| `certs` | Where certificates are stored after being signed |
| `db` | This folder contains information about signing and revoking certificates |
| `store` | Repository of signed certificates. Useful as an historical |

### Customization

All environment folders and config files are generated after this execution.

You can customize the config file just modifying the script before running it. These are some of the parameters we recommend to change to better suit your requirements:

```
######################
# -- CONFIG FILE --- #
######################

[ default ]
...
base_url                = http://repo.certs.es
...
######################
# ------- CA ------- #
######################
...
default_days            = 530
...
######################
# ------ REQ ------- #
######################
...
[ req_distinguished_name ]
countryName             = ES
stateOrProvinceName     = Spain
localityName            = Lab
organizationName        = LabCA
```

## Create Intermediate CA

This script is used to generate an intermedian CA certificate.

This certificate is created with the next x509 extensions:
- Basic Constraints: CA:TRUE, pathlen:0
- Key Usage: Digital Signature, Certificate Sign, CRL Sign
- CRL Distribution Points: URI:*<CRL_URL>*
- Certificate Policies: Any Policy
- Authority Information Access
- Subject Key Identifier
- Authority Key Identifier

### Usage

```bash
./create_int_ca.sh <root_ca_name> <ca_name>
```

### Example

```
./create_int_ca.sh mylabCA myintCA
Enter pass phrase for /home/user/LabCA/ca/myintCA.key:****
Verifying - Enter pass phrase for /home/user/LabCA/ca/myintCA.key:****
Enter pass phrase for /home/user/LabCA/ca/myintCA.key:****
Using configuration from /home/user/LabCA/ca/mylabCA.cnf
Enter pass phrase for /home/user/LabCA/ca/mylabCA.key:****
...
Certificate is to be certified until Feb  5 19:25:51 2031 GMT (3650 days)
Sign the certificate? [y/n]:y
1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
```

## Generate Certificate

This script is used to generate a CA-signed certificate.

This certificate is created with the next x509 extensions:
- Basic Constraints: CA:FALSE
- Key Usage: Digital Signature, Key Encipherment
- Extended Key Usage: TLS Web Server Authentication, TLS Web Client Authentication
- CRL Distribution Points: URI:*<CRL_URI>*
- Authority Information Access
- Subject Key Identifier
- Authority Key Identifier

### Usage

```bash
./gen_cert.sh <ca_name> <fqdn>
```

### Example

```
./gen_cert.sh mylabCA www.example.com
...
Enter pass phrase for /home/user/LabCA/ca/mylabCA.key:****
...
Certificate is to be certified until Jul 22 19:26:10 2022 GMT (530 days)
Sign the certificate? [y/n]:y
1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
```

### Wildcard Certs

This script allows the generation of a wildcard FQDN just naming it with the word "Wildcard".
An example:

```
./gen_cert.sh mylabCA wildcard.example.com
```

## Generate OCSP Certificate

This script is used to generate a OCSP certificate, used for signing OCSP responses.

This certificate is created with the next x509 extensions:
- Basic Constraints: CA:FALSE
- Key Usage: Digital Signature, Non Repudiation, Key Encipherment
- Extended Key Usage: OCSP Signing
- Subject Key Identifier
- Authority Key Identifier

### Usage

```bash
./gen_ocsp.sh <ca_name>
```

### Example

```
./gen_ocsp.sh mylabCA
...
Enter pass phrase for /home/user/LabCA/ca/mylabCA.key:****
...
Certificate is to be certified until Jul 22 19:26:32 2022 GMT (530 days)
Sign the certificate? [y/n]:y
1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
```

## Generate CRL Certificate

This script is used to generate a CRL certificate, used for CRL validation.

This certificate is created with the next x509 extensions:
- CRL Number: <serial_number>
- Authority Information Access
- Authority Key Identifier

### Usage

```bash
./gen_crl.sh <ca_name>
```

### Example

```
./gen_crl.sh mylabCA
Enter pass phrase for /home/user/LabCA/ca/mylabCA.key:****
```

## Transalte To PKCS#12

This script translates one existing certificate to PKCS#12 format.
The certificate must exist in your *certs/* folder.

### Usage

```bash
./gen_pkcs12.sh <fqdn>
./gen_pkcs12.sh <intermedian_ca_name> <fqdn>
```

### Example

```
./gen_pkcs12.sh www.example.com
Enter Export Password:****
Verifying - Enter Export Password:****
```

## Revoke A Certificate

It revokes one certificate by serial number. There exists a repository of signed certificates in *store/*, the best way to proceed is to search there what certificate you want to revoke and then copy the SN to used later.

### Usage

```bash
./revoke_sn.sh <ca_name> <cert_sn>
```

### Example

```
./revoke_sn.sh mylabCA 8A6BE4D49999ACDD
Enter pass phrase for /home/user/LabCA/ca/mylabCA.key:****
Revoking Certificate 8A6BE4D49999ACDD.
Data Base Updated
```

## Initiate OCSP Responder

It runs an OCSP responder listening on port 8080. One initial requirement to execute this is to generate a CA OCSP certificate previously.

### Usage

```bash
./ocsp_responder.sh <ca_name>
```

### Example

```
./ocsp_responder.sh mylabCA
Waiting for OCSP client connections...
```

## Reset Your Environment

This is an easy way to reset all your environment, removing all your folders and certificates to start again from the beginning.

### Usage

```bash
./clear_env.sh
```

### Example

```
./clear_env.sh
Continue (y/n)?y
Removing folders.
```
