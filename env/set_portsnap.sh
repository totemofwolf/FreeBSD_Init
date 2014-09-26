#!/bin/sh
# filename:set_portsnap.sh
# author:wanglang@ihczd.com
# version:0.9.0
# date:2014-08-05

ETC_PATH="/etc"

echo "====================================Ⅷ $ETC_PATH/portsnap.conf===========================================" | tee -a $LOGFILE
echo "-----------------------add portsnap.conf proc log begin---------------------" | tee -a $LOGFILE


if [ -f "$ETC_PATH/portsnap.conf.orig" ]; then
	echo -e "\033[1;40;31mInfo:	@$ETC_PATH/portsnap.conf file exists,Skip..\033[0m" | tee -a $LOGFILE
else
\cp -av $ETC_PATH/portsnap.conf $ETC_PATH/portsnap.conf.orig | tee -a $LOGFILE
echo "writing portsnap.conf..." | tee -a $LOGFILE
sed -i '' -e 's|SERVERNAME=portsnap.FreeBSD.org|SERVERNAME=portsnap.hshh.org|' /etc/portsnap.conf
echo "write portsnap.conf done!!" | tee -a $LOGFILE
echo -e "\033[1;40;31mInfo:	@portsnap.conf Add the following lines:\033[0m" | tee -a $LOGFILE
tail $ETC_PATH/portsnap.conf | grep SERVERNAME | tee -a $LOGFILE
fi

echo "-----------------------add portsnap.conf proc log end---------------------" | tee -a $LOGFILE
echo "====================================Ⅷ $ETC_PATH/portsnap.conf===========================================" | tee -a $LOGFILE
