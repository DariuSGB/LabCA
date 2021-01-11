#########################################################################
# title: gen_cert.sh                                                    #
# author: Dario Garrido                                                 #
# date: 20210105                                                        #
# description: Create and sign a new certificate for a defined FQDN     #
#              It supports wildcard FQDN like wildcard.example.com      #
# usage: ./gen_cert.sh <ca_name> <fqdn>                                 #
#########################################################################

#!/bin/sh

if [ "$#" -ne 2 ]
then
  echo "Usage: <ca_name> <fqdn>"
  exit 1
fi

CA=$1
DOMAIN=$2
#FOLDER=.
FOLDER=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

sed -i -E "s/(^fqdn\s+=\s).*/\1$(echo $DOMAIN | sed -E "s/[Ww]ildcard/\*/")/" $FOLDER/ca/$CA.cnf

openssl req -new -config $FOLDER/ca/$CA.cnf -out $FOLDER/certs/$DOMAIN.csr -keyout $FOLDER/certs/$DOMAIN.key -nodes
openssl ca -config $FOLDER/ca/$CA.cnf -in $FOLDER/certs/$DOMAIN.csr -out $FOLDER/certs/$DOMAIN.crt
