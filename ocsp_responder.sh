#########################################################################
# title: ocsp_responder.sh                                              #
# author: Dario Garrido                                                 #
# date: 20210105                                                        #
# description: Run an OCSP responder on port 8080                       #
# usage: ./ocsp_responder.sh <ca_name>                                  #
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
openssl ocsp -index $FOLDER/db/$CA.db -port 8080 -rsigner $FOLDER/ca/$CA.ocsp.crt -rkey $FOLDER/ca/$CA.ocsp.key -CA $FOLDER/ca/$CA.crt -text -out $FOLDER/ocsp_log.txt -ignore_err
