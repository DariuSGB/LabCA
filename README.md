# LabCA
The main goal of this repository is to get an easy way to create your own certificate CA for using it in your lab enviroment

## Installation

```bash
git clone https://github.com/DariuSGB/LabCA.git
cd LabCA
chmod +x $(ls | grep -v README)
```

## Description

| Script | Descripción |
| --- | --- |
| `create_root_ca.sh` | generate a CA certificate and store it in *./ca/* |
| `create_int_ca.sh` | generate an intermediate CA signed by the root CA and store it in *./ca/* |
| `gen_cert.sh` | generate an certificate signed by the defined CA and store it in *./cert/* |
| `gen_ocsp.sh` | generate an OCSP certificate for signing OCSP requests and store it in *./ca/* |
| `gen_crl.sh` | generate a CRL certificate and store it in *./ca/* |
| `revoke_sn.sh` | revoke a certificate base on serial number |
| `gen_pkcs12.sh` | generate a PKCS#12 certificate from a PEM certificate provided |
| `ocsp_responder.sh` | generate a OCSP responder for listening requests on port 8080 |
| `clear_env.sh` | clear all (folders and certs) |

## Create CA

### Usage

```bash
./create_root_ca.sh <ca_name>
```

### Example

```bash
./create_root_ca.sh mylabCA
```

## Create Intermediate CA

### Usage

./create_int_ca.sh <root_ca_name> <ca_name>

### Example

./create_int_ca.sh mylabCA myintCA
