#########################################################################
# title: create_int_ca.sh                                               #
# author: Dario Garrido                                                 #
# date: 20210105                                                        #
# description: Create enviroment and intermediate CA                    #
# usage: ./create_int_ca.sh <root_ca_name> <ca_name>                    #
#########################################################################

#!/bin/sh

if [ "$#" -ne 2 ]
then
  echo "Usage: <root_ca_name> <ca_name>"
  exit 1
fi

CA1=$1
CA2=$2
FOLDER=.

mkdir -p $FOLDER/store/$CA2

cp $FOLDER/ca/$CA1.cnf $FOLDER/ca/$CA2.cnf
sed -i -E "s/(^dir\s+=\s).*/\1$FOLDER/" $FOLDER/ca/$CA2.cnf
sed -i -E "s/(^ca\s+=\s).*/\1$CA2/" $FOLDER/ca/$CA2.cnf
sed -i -E "s/(^fqdn\s+=\s).*/\1$CA2/" $FOLDER/ca/$CA2.cnf
sed -i -E "s/(^fqdn\s+=\s).*/\1$CA2/" $FOLDER/ca/$CA1.cnf
sed -i -E "s/(^x509_extensions\s+=\s).*/\1chain_ext/" $FOLDER/ca/$CA1.cnf

openssl genrsa -aes256 -out $FOLDER/ca/$CA2.key 2048
openssl req -new -out $FOLDER/ca/$CA2.csr -key $FOLDER/ca/$CA2.key -config $FOLDER/ca/$CA2.cnf
openssl ca -days 3650 -config $FOLDER/ca/$CA1.cnf -in $FOLDER/ca/$CA2.csr -out $FOLDER/ca/$CA2.crt

sed -i -E "s/(^x509_extensions\s+=\s).*/\1x509_ext/" $FOLDER/ca/$CA1.cnf

SRLHEX=$(openssl x509 -noout -serial -in $FOLDER/ca/$CA2.crt | awk -F "=" '{print$2}')
SRLDEC=$((16#$SRLHEX))
NSRLDEC=$(($SRLDEC + 1))
NSRLHEX=$(printf '%X\n' $NSRLDEC)

echo -e "$NSRLHEX" > $FOLDER/db/$CA2.crt.srl
echo -e "01" > $FOLDER/db/$CA2.crl.srl
touch $FOLDER/db/$CA2.db
