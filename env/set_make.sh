#!/bin/sh
# filename:set_make.sh
# author:wanglang@ihczd.com
# version:1.0.0
# date:2014-08-09

CPU_NUM=`sysctl kern.smp.cpus | awk '{print $2}'`
ETC_PATH="/etc"

DATE=`date +%Y%m%d%H%M`
echo "====================================Ⅲ $ETC_PATH/make.conf===========================================" | tee -a $LOGFILE
echo "-----------------------add make.conf proc log begin---------------------" | tee -a $LOGFILE

####---- CPU type detection ----begin####
if sysctl hw.model | grep -i "Core"; then
	CPU_TYPE=corei7
else
	CPU_TYPE=nocona
fi
export CPU_TYPE
####---- CPU type detection ----end####


if [ -f "$ETC_PATH/make.conf" ]; then
	echo -e "\033[1;40;31mInfo:	@$ETC_PATH/make.conf file exists,Skip..\033[0m" | tee -a $LOGFILE
else
\cp -av /usr/share/examples$ETC_PATH/make.conf $ETC_PATH/make.conf | tee -a $LOGFILE
echo "writing make.conf..." | tee -a $LOGFILE
cat >> $ETC_PATH/make.conf << EOF

# hczdyw add
MASTER_SITE_BACKUP?=http://ports.hshh.org/\${DIST_SUBDIR}/ \\
ftp://ftp8.tw.freebsd.org/pub/FreeBSD/distfiles/\${DIST_SUBDIR}/ \\
http://mirrors.ustc.edu.cn/freebsd/distfiles/\${DIST_SUBDIR}/ \\
ftp://ftp.freebsdchina.org/pub/FreeBSD/ports/distfiles/\${DIST_SUBDIR}/ \\
http://distcache.FreeBSD.org/ports-distfiles/\${DIST_SUBDIR}/
MASTER_SITE_OVERRIDE?=\${MASTER_SITE_BACKUP}

FETCH_CMD=wget -c -t 4 -S
DISABLE_SIZE=YES

#===============================================================================
# use clang/clang++ for ports
#===============================================================================
.if !empty(.CURDIR:M/usr/ports/*)
CC=clang
CXX=clang++
CPP=clang-cpp
.endif

# ports compling flag
CFLAGS=	-O2 -fno-strict-aliasing -pipe -mssse3
CXXFLAGS+= -mssse3

# kernel compilation flag
COPTFLAGS= -O2 -pipe -funroll-loops -ffast-math -fno-strict-aliasing

CPUTYPE?=$CPU_TYPE #配合默认自带的clang编译器，适用于core i系列的CPU

#only install old files ( compare files installed && to be installed)
INSTALL=install -C

# documentation language(只安装英文文档)
DOC_LANG=en_US.ISO8859-1
# for textproc/docproj
OPTIONS_SET=JADETEX #WITH_JADETEX=YES

#===============================================================================
# build world options
#===============================================================================
# avoid compiling profiled libraries
NO_PROFILE=true


#===============================================================================
# ports make config options
#===============================================================================
# set server for distfiles
BUILD_OPTIMIZED=YES
BUILD_STATIC=YES
NO_X=YES
NO_X11=YES
ENABLE_GUI=NO
OPTIONS_SET=CPUFLAGS #WITH_CPUFLAGS=YES
OPTIONS_SET=OPENSSL #WITH_OPENSSL_PORT=yes
OPTIONS_UNSET=X11 #WITHOUT_X11=true
OPTIONS_UNSET=GUI
OPTIONS_UNSET=TK
OPTIONS_UNSET=DEBUG #WITHOUT_DEBUG=YES
OPTIONS_UNSET=IPV6 #X.IPV6.Print OPTIONS_FILE_UNSET+=IPV6
OPTIONS_UNSET=NLS  #OPTIONS_FILE_UNSET+=NLS
OPTIONS_UNSET=PRINT
OPTIONS_UNSET=NOUVEAU  #WITHOUT_NOUVEAU=yes
#WITH_OPTIMIZED_CFLAGS=YES
#OPTIMIZED_CFLAGS=YES


MAKE_JOBS_UNSAFE=YES
MAKE_JOBS_NUMBER=$CPU_NUM #multi thread compling..

#===============================================================================
# ports build options
#===============================================================================
WRKDIRPREFIX=/tmp

# leave out the warning...
NO_WARNING_PKG_INSTALL_EOL=YES

BATCH=yes
EOF
echo "write make.conf done!!" | tee -a $LOGFILE
echo -e "\033[1;40;31mInfo:	@make.conf Add the following lines:\033[0m" | tee -a $LOGFILE
tail -n 52 $ETC_PATH/make.conf | tee -a $LOGFILE
fi

echo "-----------------------add make.conf proc log end---------------------" | tee -a $LOGFILE
echo "====================================Ⅲ $ETC_PATH/make.conf===========================================" | tee -a $LOGFILE
