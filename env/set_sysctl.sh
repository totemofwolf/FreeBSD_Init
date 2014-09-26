#!/bin/sh
# filename:set_sysctl.sh
# author:wanglang@ihczd.com
# version:1.0.0
# date:2014-08-09

ETC_PATH="/etc"
BASE_DIR="/root/work"
DATE=`date +%Y%m%d%H%M`

echo "====================================Ⅰ $ETC_PATH/sysctl.conf ===========================================" | tee -a $LOGFILE
echo "-----------------------add $ETC_PATH/sysctl.conf proc log begin---------------------" | tee -a $LOGFILE
# sysctl tuning
if cat $ETC_PATH/sysctl.conf | grep "hczdyw add"; then
	echo -e "\033[1;40;31mInfo:	@$ETC_PATH/sysctl.conf hczdyw add exists,Skip..\033[0m" | tee -a $LOGFILE
else
\cp -av $ETC_PATH/sysctl.conf $ETC_PATH/sysctl.conf.orig
cat >> $ETC_PATH/sysctl.conf << EOF

# hczdyw add
net.inet.tcp.sendspace=65536
net.inet.tcp.recvspace=65536
net.inet.udp.maxdgram=65535
net.local.stream.sendspace=65535
# This should be enabled if you going to use big spaces (>64k)
# Also timestamp field is useful when using syncookies
net.inet.tcp.rfc1323=1
net.inet.tcp.rfc3042=1
net.inet.tcp.rfc3390=1
# Disable randomizing of ports to avoid false RST
# Before use check SA here www.bsdcan.org/2006/papers/ImprovingTCPIP.pdf
# Note: Port randomization autodisables at high connection rates
net.inet.ip.portrange.randomized=0
# Dtops route cache degradation during a DDoS.
# http://www.freebsd.org/doc/en/books/handbook/securing-freebsd.html
#net.inet.ip.rtexpire=2
net.inet.ip.rtminexpire=2
net.inet.ip.rtmaxcache=1024
net.inet.tcp.log_in_vain=1
net.inet.udp.log_in_vain=1
net.inet.tcp.delayed_ack=0
# Security
net.inet.ip.redirect=0
net.inet6.ip6.redirect=0
net.inet.icmp.log_redirect=0 
net.inet.icmp.drop_redirect=1
# Increases default TTL
# Default is 64
net.inet.ip.ttl=128
net.inet.tcp.drop_synfin=1
net.inet.icmp.bmcastecho=0
net.inet.icmp.maskrepl=0
net.inet.icmp.icmplim=100
net.inet.icmp.icmplim_output=0
net.inet.ip.random_id=1
net.inet.tcp.always_keepalive=1
net.inet.ip.intr_queue_maxlen=1000
# Lessen max segment life to conserve resources
# ACK waiting time in milliseconds
# (default: 30000. RFC from 1979 recommends 120000)
net.inet.tcp.msl=5000 
# Max number of time-wait sockets
net.inet.tcp.maxtcptw=200000
# FIN_WAIT_2 state fast recycle
net.inet.tcp.fast_finwait2_recycle=1
# Time before tcp keepalive probe is sent
# default is 2 hours (7200000)
net.inet.tcp.keepidle=60000
# Use HTCP congestion control (don't forget to load cc_htcp kernel module)
net.inet.tcp.cc.algorithm=htcp
# Should be increased until net.inet.ip.intr_queue_drops is zero
net.inet.ip.intr_queue_maxlen=4096
# Should be increased when you have A LOT of files on server 
# (Increase until vfs.ufs.dirhash_mem becomes lower)
vfs.ufs.dirhash_maxmem=67108864
net.inet.tcp.blackhole=2
net.inet.udp.blackhole=1
net.inet.ip.fastforwarding=0
security.bsd.see_other_uids=0
net.inet.udp.checksum=1
net.inet.tcp.syncookies=1
net.local.stream.recvspace=65536
net.local.dgram.maxdgram=16384
net.local.dgram.recvspace=65536
net.inet.tcp.mssdflt=1460
net.inet.tcp.minmss=1460
net.inet.raw.maxdgram=65536
net.inet.raw.recvspace=65536
#net.inet.ip.fw.dyn_max=65535
#net.inet.udp.sendspace=65535
#net.inet.ipf.fr_tcpidletimeout=864000
#net.inet.tcp.inflight.enable=1
#net.inet.tcp.rfc1644=1
# Max backlog size
# Note Application can still limit it by passing second argument to listen(2) syscall
# Note: Listen queue be monitored via Current listen queue sizes (qlen/incqlen/maxqlen)
kern.ipc.somaxconn=32768	#?
kern.ipc.shm_use_phys=1
kern.ipc.shmmax=2147483648 # 1/2 RAM
kern.ipc.shmall=524288	   # kern.ipc.shmmax/(4*1024=4K)
# Sockets
kern.ipc.maxsockets=204800
# Every socket is a file, so increase them
kern.maxfiles=204800
kern.maxfilesperproc=200000
kern.maxvnodes=200000
kern.ipc.maxsockbuf=2097152
# Servers with threading software apache2 / Pound may want to rise following sysctl
kern.threads.max_threads_per_proc=4096
EOF

echo -e "\033[1;40;31mInfo:	@$ETC_PATH/sysctl.conf Add the following lines:\033[0m" | tee -a $LOGFILE
tail -n 46 $ETC_PATH/sysctl.conf | tee -a $LOGFILE

fi

echo "-----------------------add $ETC_PATH/sysctl.conf proc log end---------------------" | tee -a $LOGFILE
echo "Ⅰ==================================== $ETC_PATH/sysctl.conf ===========================================" | tee -a $LOGFILE
