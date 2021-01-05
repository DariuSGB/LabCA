#########################################################################
# title: revoke_sn.sh                                                   #
# author: Dario Garrido                                                 #
# date: 20210105                                                        #
# description: Revoke a certificate by SN                               #
# usage: ./revoke_sn.sh <ca_name> <cert_sn>                             #
#########################################################################

#!/bin/sh

if [ "$#" -ne 2 ]
then
  echo "Usage: <ca_name> <cert_sn>"
  exit 1
fi

CA=$1
SERIAL=$2
FOLDER=.

openssl ca -config $FOLDER/ca/$CA.cnf -revoke $FOLDER/store/$CA/$SERIAL.pem
