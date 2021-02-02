# LabCA
The main goal of this repository is to get an easy way to create your own certificate CA for using it in your lab enviroment.

## Installation

```bash
git clone https://github.com/DariuSGB/LabCA.git
cd LabCA
chmod +x $(ls | grep -v README)
```

## Description

| Script | Descripción |
| --- | --- |
| `create_root_ca.sh` | generate a CA certificate and store it in **./ca/** |
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

```bash
./create_root_ca.sh mylabCA
```

### Customization

All environment folders and config file is generated after this execution.

You can customize the config file before running this script. These are some of the parameters that we recommend to change:

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
commonName              = \$fqdn
```

## Create Intermediate CA

This script is used to generate an intermedian CA certificate.

This certificate is created with the next x509 extensions:
- Basic Constraints: CA:TRUE, pathlen:0
- Key Usage: Digital Signature, Certificate Sign, CRL Sign
- CRL Distribution Points: URI:*<CRL_URI>*
- Certificate Policies: Any Policy
- Authority Information Access
- Subject Key Identifier
- Authority Key Identifier

### Usage

```bash
./create_int_ca.sh <root_ca_name> <ca_name>
```

### Example

```bash
./create_int_ca.sh mylabCA myintCA
```

## Create Certificate

### Usage

```bash
./gen_cert.sh <ca_name> <fqdn>
```

### Example

```bash
./gen_cert.sh mylabCA www.example.com
```
