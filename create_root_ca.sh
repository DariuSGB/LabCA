#########################################################################
# title: create_root_ca.sh                                              #
# author: Dario Garrido                                                 #
# date: 20210105                                                        #
# description: Create enviroment and Root CA                            #
# usage: ./create_root_ca.sh <ca_name>                                  #
#########################################################################

#!/bin/sh

if [ "$#" -ne 1 ]
then
  echo "Usage: <ca_name>"
  exit 1
fi

CA=$1
#FOLDER=.
FOLDER=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

mkdir -p $FOLDER/store/$CA
mkdir $FOLDER/certs
mkdir $FOLDER/db
mkdir $FOLDER/ca

cat > $FOLDER/ca/$CA.cnf << EOF

######################
# -- CONFIG FILE --- #
######################

[ default ]
ca                      = $CA
fqdn                    = $CA
dir                     = $FOLDER
base_url                = http://repo.certs.es
aia_url                 = \$base_url/\$ca.crt
crl_url                 = \$base_url/\$ca.crl

######################
# ------- CA ------- #
######################

[ ca ]
default_ca              = identity_ca

[ identity_ca ]
certificate             = \$dir/ca/\$ca.crt
private_key             = \$dir/ca/\$ca.key
crl                     = \$dir/ca/\$ca.crl
crl_dir                 = \$dir/ca
new_certs_dir           = \$dir/store/\$ca
serial                  = \$dir/db/\$ca.crt.srl
crlnumber               = \$dir/db/\$ca.crl.srl
database                = \$dir/db/\$ca.db
unique_subject          = no
default_days            = 530
default_md              = sha256
policy                  = my_policy
preserve                = no
email_in_dn             = no
name_opt                = multiline, -esc_msb, utf8
cert_opt                = ca_default
#copy_extensions        = copy
x509_extensions         = x509_ext
default_crl_days        = 90
crl_extensions          = crl_ext

[ my_policy ]
countryName             = supplied
stateOrProvinceName     = optional
localityName            = optional
organizationName        = supplied
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

######################
# ------ REQ ------- #
######################

[ req ]
prompt                  = no
default_bits            = 2048
default_md              = sha256
utf8                    = yes
string_mask             = utf8only
distinguished_name      = req_distinguished_name
x509_extensions         = ca_ext
#req_extensions         = req_ext

[ req_distinguished_name ]
countryName             = ES
stateOrProvinceName     = Spain
localityName            = Lab
organizationName        = LabCA
commonName              = \$fqdn

######################
# --- EXTENSIONS --- #
######################

[ ca_ext ]
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid:always, issuer:always
basicConstraints        = CA:TRUE

[ req_ext ]
subjectKeyIdentifier    = hash
subjectAltName          = @san_info
keyUsage                = critical, digitalSignature, keyEncipherment
extendedKeyUsage        = serverAuth, clientAuth
crlDistributionPoints   = @crl_info
authorityInfoAccess     = @issuer_info
basicConstraints        = critical, CA:FALSE

[ chain_ext ]
basicConstraints        = critical, CA:TRUE, pathlen:0
keyUsage                = critical, digitalSignature, keyCertSign, cRLSign
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid, issuer
authorityInfoAccess     = @issuer_info
crlDistributionPoints   = @crl_info
certificatePolicies     = 2.5.29.32.0

[ x509_ext ]
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid, issuer
subjectAltName          = @san_info
keyUsage                = critical, digitalSignature, keyEncipherment
extendedKeyUsage        = serverAuth, clientAuth
crlDistributionPoints   = @crl_info
authorityInfoAccess     = @issuer_info
basicConstraints        = critical, CA:FALSE

[ ocsp_ext ]
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid, issuer
keyUsage                = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage        = OCSPSigning
basicConstraints        = critical, CA:FALSE

[ crl_ext ]
authorityKeyIdentifier  = keyid:always
authorityInfoAccess     = @issuer_info

[ san_info ]
DNS.1                   = \$fqdn
#IP.1                   = 127.0.0.1

[ issuer_info ]
caIssuers;URI.0         = \$aia_url
OCSP;URI.0              = \$base_url

[ crl_info ]
URI.0                   = \$crl_url

EOF

openssl genrsa -aes256 -out $FOLDER/ca/$CA.key 2048
openssl req -new -x509 -days 3650 -key $FOLDER/ca/$CA.key -out $FOLDER/ca/$CA.crt -sha256 -config $FOLDER/ca/$CA.cnf

SRLHEX=$(openssl x509 -noout -serial -in $FOLDER/ca/$CA.crt | awk -F "=" '{print$2}')
SRLDEC=$((16#$SRLHEX))
NSRLDEC=$(($SRLDEC + 1))
NSRLHEX=$(printf '%X\n' $NSRLDEC)

echo -e "$NSRLHEX" > $FOLDER/db/$CA.crt.srl
echo -e "01" > $FOLDER/db/$CA.crl.srl
touch $FOLDER/db/$CA.db
