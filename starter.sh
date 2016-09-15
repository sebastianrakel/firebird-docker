#!/bin/bash

CURRENT_SYSDBA_PASSWORD=`grep -oP 'ISC_PASSWD=\K.*' /usr/local/firebird/SYSDBA.password`

/usr/local/firebird/bin/gsec -user SYSDBA -password `echo $CURRENT_SYSDBA_PASSWORD` -modify SYSDBA -pw `echo $SYSDBA_PASSWORD`

/usr/local/firebird/bin/fbguard
