#########################################################################
# title: gen_ocsp.sh                                                    #
# author: Dario Garrido                                                 #
# date: 20210105                                                        #
# description: Create an OCSP cert for signing OCSP responses           #
# usage: ./gen_ocsp.sh <ca_name>                                        #
#########################################################################

#!/bin/sh

if [ "$#" -ne 1 ]
then
  echo "Usage: <ca_name>"
  exit 1
fi

CA=$1
DOMAIN=$CA.ocsp
#FOLDER=.
FOLDER=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

sed -i -E "s/(^fqdn\s+=\s).*/\1$DOMAIN/" $FOLDER/ca/$CA.cnf

sed -i -E "s/(^x509_extensions\s+=\s).*/\1ocsp_ext/" $FOLDER/ca/$CA.cnf

openssl req -new -config $FOLDER/ca/$CA.cnf -out $FOLDER/ca/$DOMAIN.csr -keyout $FOLDER/ca/$DOMAIN.key -nodes
openssl ca -config $FOLDER/ca/$CA.cnf -in $FOLDER/ca/$DOMAIN.csr -out $FOLDER/ca/$DOMAIN.crt

sed -i -E "s/(^x509_extensions\s+=\s).*/\1x509_ext/" $FOLDER/ca/$CA.cnf
