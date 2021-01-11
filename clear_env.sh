#########################################################################
# title: clear_env.sh                                                   #
# author: Dario Garrido                                                 #
# date: 20210105                                                        #
# description: Clear your enviroment                                    #
# usage: ./clear_env.sh                                                 #
#########################################################################

#!/bin/sh

#FOLDER=.
FOLDER=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

rm -Rf $FOLDER/ca/ $FOLDER/certs/ $FOLDER/db/ $FOLDER/store/
