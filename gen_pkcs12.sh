#########################################################################
# title: gen_pkcs12.sh                                                  #
# author: Dario Garrido                                                 #
# date: 20210108                                                        #
# description: Encapsulate cert and key in a single PKCS#12 file        #
# usage: ./gen_pkcs12.sh <fqdn>                                         #
# usage: ./gen_pkcs12.sh <intermedian_ca_name> <fqdn>                   #
#########################################################################

#!/bin/sh

if [ "$#" -eq 1 ]
then
  FOLDER=.
  DOMAIN=$1
  openssl pkcs12 -export -in $FOLDER/certs/$DOMAIN.crt -inkey $FOLDER/certs/$DOMAIN.key -out $FOLDER/certs/$DOMAIN.p12
elif [ "$#" -eq 2 ]
then
  FOLDER=.
  CA=$1
  DOMAIN=$2
  openssl pkcs12 -export -in $FOLDER/certs/$DOMAIN.crt -inkey $FOLDER/certs/$DOMAIN.key -out $FOLDER/certs/$DOMAIN.p12 -certfile $FOLDER/ca/$CA.crt
else
  echo "Usage: <fqdn>"
  echo "Usage: <intermedian_ca_name> <fqdn>"
  exit 1
fi
