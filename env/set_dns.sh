#!/bin/sh
# filename:set_dns.sh
# author:wanglang@ihczd.com
# version:0.9.0
# date:2014-08-05

ETC_PATH="/etc"

DATE=`date +%Y%m%d%H%M`
echo "====================================Ⅴ $ETC_PATH/resolv.conf===========================================" | tee -a $LOGFILE
echo "-----------------------add DNS proc log begin---------------------" | tee -a $LOGFILE

# DNS tuning
if cat $ETC_PATH/resolv.conf | grep "hczdyw add" ;then
	echo -e "\033[1;40;31mInfo:	@$ETC_PATH/resolv.conf hczdyw add exists,Skip..\033[0m" | tee -a $LOGFILE
else
\cp $ETC_PATH/resolv.conf $ETC_PATH/resolv.conf.orig
cat > $ETC_PATH/resolv.conf << EOF
# hczdyw add
nameserver 223.5.5.5
nameserver 223.6.6.6
nameserver 114.114.114.114
EOF
echo -e "\033[1;40;31mInfo:	@$ETC_PATH/resolv.conf Add the following lines:\033[0m" | tee -a $LOGFILE
tail -n 4 $ETC_PATH/resolv.conf | tee -a $LOGFILE
fi

echo "-----------------------add DNS proc log end---------------------" | tee -a $LOGFILE
echo "====================================Ⅴ $ETC_PATH/resolv.conf===========================================" | tee -a $LOGFILE
