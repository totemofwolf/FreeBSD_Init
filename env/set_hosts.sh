#!/bin/sh
# filename:install_set_loader_conf.sh
# author:wanglang@ihczd.com
# version:1.0.0
# date:2014-08-09

HOSTNAME=`uname -n`
# or HOSTNAME=`hostname`
ETC_PATH="/etc"

BASE_DIR="/root/work"

DATE=`date +%Y%m%d%H%M`

echo "====================================Ⅳ $ETC_PATH/hosts===========================================" | tee -a $LOGFILE
echo "-----------------------add hosts proc log begin---------------------" | tee -a $LOGFILE

if cat $ETC_PATH/hosts | grep "$HOSTNAME"; then
	echo -e "\033[1;40;31mInfo:	@$ETC_PATH/hosts hostname exists,Skip..\033[0m" | tee -a $LOGFILE
else
\cp -av $ETC_PATH/hosts $ETC_PATH/hosts.orig | tee -a $LOGFILE
sed -i '' '/127.0.0.1/'d $ETC_PATH/hosts | tee -a $LOGFILE
cat >> $ETC_PATH/hosts << EOF
127.0.0.1		localhost localhost.my.domain $HOSTNAME
183.136.223.25	www.taou365.com
183.129.160.60	www.ihczd.com
183.129.178.172	www.hcyy365.com
183.136.236.136	www.cheduihui.com
EOF
echo "write hosts done!!" | tee -a $LOGFILE
echo -e "\033[1;40;31mInfo:	@$ETC_PATH/hosts Add the following lines:\033[0m" | tee -a $LOGFILE
cat $ETC_PATH/hosts | grep "$HOSTNAME" | tee -a $LOGFILE	
fi

echo "-----------------------add hosts proc log begin---------------------" | tee -a $LOGFILE
echo "====================================Ⅳ $ETC_PATH/hosts===========================================" | tee -a $LOGFILE
