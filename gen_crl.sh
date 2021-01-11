#########################################################################
# title: gen_crl.sh                                                     #
# author: Dario Garrido                                                 #
# date: 20210105                                                        #
# description: Create a CRL cert                                        #
# usage: ./gen_crl.sh <ca_name>                                         #
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

openssl ca -config $FOLDER/ca/$CA.cnf -gencrl -out $FOLDER/ca/$CA.crl
