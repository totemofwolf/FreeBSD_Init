#!/bin/sh
# filename:set_sysctl.sh
# author:wanglang@ihczd.com
# version:0.9.0
# date:2014-08-05

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
net.inet.tcp.sendspace=65536 #32768
# Small receive space, only usable on http-server, on file server this
# should be increased to 65535 or even more
net.inet.tcp.recvspace=65536
net.inet.udp.maxdgram=65535 #9216
net.local.stream.sendspace=65535 #8192
# Disable randomizing of ports to avoid false RST
# Before use check SA here www.bsdcan.org/2006/papers/ImprovingTCPIP.pdf
# Note: Port randomization autodisables at high connection rates
net.inet.ip.portrange.randomized=0 #^
# Dtops route cache degradation during a DDoS.
# http://www.freebsd.org/doc/en/books/handbook/securing-freebsd.html
# Spoofed packet attacks may be used to overload the kernel route cache. A
# spoofed packet attack uses random source IPs to cause the kernel to generate
# a temporary cached route in the route table, Route cache is an extraneous
# caching layer mapping interfaces to routes to IPs and saves a lookup to the
# Forward Information Base (FIB); a routing table within the network stack. The
# IPv4 routing cache was intended to eliminate a FIB lookup and increase
# performance. While a good idea in principle, unfortunately it provided a very
# small performance boost in less than 10% of connections and opens up the
# possibility of a DoS vector. Setting rtexpire and rtminexpire to two(2)
# seconds should be sufficient to protect the route table from attack.
# http://www.es.freebsd.org/doc/handbook/securing-freebsd.html
net.inet.ip.rtexpire=2       # (default 3600)
net.inet.ip.rtminexpire=2    # (default 10  )
net.inet.ip.rtmaxcache=1024 #128
net.inet.tcp.log_in_vain=1 #^
net.inet.udp.log_in_vain=1 #^
net.inet.tcp.delayed_ack=0 #^
# Increases default TTL
# Default is 64
#net.inet.ip.ttl=128 #64 is fine for most instances [Optional]
net.inet.icmp.bmcastecho=0
net.inet.icmp.maskrepl=0
net.inet.icmp.icmplim=100 #200
net.inet.icmp.icmplim_output=0 #^
net.inet.ip.random_id=1 #^
net.inet.tcp.always_keepalive=1
net.inet.ip.intr_queue_maxlen=1000 #256
# Max number of time-wait sockets
net.inet.tcp.maxtcptw=200000 #5120
# Time before tcp keepalive probe is sent
# default is 2 hours (7200000)
net.inet.tcp.keepidle=60000 #2 hours (7200000)
# Use HTCP congestion control (don't forget to load cc_htcp kernel module)
net.inet.tcp.cc.algorithm=htcp #newreno other:(cubic,vegas,caia delay)
# Should be increased until net.inet.ip.intr_queue_drops is zero
net.inet.ip.intr_queue_maxlen=4096 #256
# Should be increased when you have A LOT of files on server 
# (Increase until vfs.ufs.dirhash_mem becomes lower)
vfs.ufs.dirhash_maxmem=67108864 #6840320
net.inet.ip.forwarding=1      # (default 0)
net.inet.ip.fastforwarding=1  # (default 0) net.inet.ip.fastforwarding=0
net.inet.udp.checksum=1
net.inet.tcp.syncookies=1
net.local.stream.recvspace=65536 #8192
net.local.dgram.maxdgram=16384 #2048
net.local.dgram.recvspace=65536 #4096
########################################Anti DDos begin##################################
net.inet.tcp.fast_finwait2_recycle=1  # recycle FIN/WAIT states quickly (helps against DoS, but may cause false RST) (default 0)
net.inet.tcp.icmp_may_rst=0           # icmp may not send RST to avoid spoofed icmp/udp floods (default 1)
security.bsd.see_other_uids=0 #^ [Optional]
# Lessen max segment life to conserve resources
# ACK waiting time in milliseconds
# (default: 30000. RFC from 1979 recommends 120000)
net.inet.tcp.msl=5000 #30000
net.inet.tcp.blackhole=2 #0
net.inet.udp.blackhole=1 #^
net.inet.tcp.path_mtu_discovery=0     # disable MTU discovery since most ICMP type 3 packets are dropped by others (default 1)
# FIN_WAIT_2 state fast recycle
net.inet.tcp.fast_finwait2_recycle=1 #^
net.inet.tcp.drop_synfin=1 #^
# Security
net.inet.ip.redirect=0 #^
net.inet6.ip6.redirect=0 #^
net.inet.icmp.log_redirect=0 
net.inet.icmp.drop_redirect=1 #^
net.inet.ip.process_options=0         # ignore IP options in the incoming packets (default 1)
net.inet.ip.check_interface=1         # verify packet arrives on correct interface (default 0)
########################################Anti DDos end##################################
# maximum segment size (MSS) specifies the largest payload of data in a single TCP segment
# 1460 for a IPv4 1500 MTU network: MTU - 40 IPv4 header
# 8960 for a IPv4 9000 MTU network: MTU - 40 IPv4 header and switch ports set at 9216
# For most non-VPN networks an MTU of 1460 should work fine, but you may want
# to be cautious and use 1448. A smaller MSS allows an extra 12 bytes of space
# for additional TCP options like TCP time stamps (net.inet.tcp.rfc1323). If an
# MTU is too large, the packet must be fragmented by routers or the client
# which causes extra processing, delays and slow down of the transfer. If you
# are using PF with an outgoing scrub rule then PF will re-package the data
# using an MTU of 1460 by default, thus overiding this mssdflt setting.
# http://www.wand.net.nz/sites/default/files/mss_ict11.pdf 
net.inet.tcp.mssdflt=1460  # (default 536)
net.inet.tcp.minmss=1460 #216
# Do not create a socket or compressed tcpw for TCP connections restricted to
# the local machine connecting to itself on localhost. An example connection
# would be a web server and a database server running on the same machine or
# freebsd jails connecting to each other. 
net.inet.tcp.nolocaltimewait=1  # (default 0)
# Reduce the amount of SYN/ACKs the server will re-transmit to an ip address
# whom did not respond to the first SYN/ACK. On a client's initial connection
# our server will always send a SYN/ACK in response to the client's initial
# SYN. Limiting retranstited SYN/ACKS reduces local syn cache size and a "SYN
# flood" DoS attack's collateral damage by not sending SYN/ACKs back to spoofed
# ips, multiple times. If we do continue to send SYN/ACKs to spoofed IPs they
# may send RST's back to us and an "amplification" attack would begin against
# our host. If you do not wish to send retransmits at all then set to zero(0)
# especially if you are under a SYN attack. If our first SYN/ACK gets dropped
# the client will re-send another SYN if they still want to connect. Also set
# "net.inet.tcp.msl" to two(2) times the average round trip time of a client,
# but no lower then 5000ms (5s). Test with "netstat -s -p tcp" and look under
# syncache entries.
# http://people.freebsd.org/~jlemon/papers/syncache.pdf
# http://www.ouah.org/spank.txt
net.inet.tcp.syncache.rexmtlimit=0  # (default 3)
net.inet.raw.maxdgram=65536 #9216
net.inet.raw.recvspace=65536 #9216
# Max backlog size
# Note Application can still limit it by passing second argument to listen(2) syscall
# Note: Listen queue be monitored via Current listen queue sizes (qlen/incqlen/maxqlen)
kern.ipc.shm_use_phys=1
kern.ipc.somaxconn=32768	#?
kern.ipc.shmmax=2147483648 # 1/2 RAM
kern.ipc.shmall=524288	   # kern.ipc.shmmax/(4*1024=4K)
# Sockets
kern.ipc.maxsockets=204800 #25600
# Every socket is a file, so increase them
kern.maxfiles=204800 #12328
kern.maxfilesperproc=200000 #11095
kern.maxvnodes=200000 #142942
kern.ipc.maxsockbuf=4194304
net.inet.tcp.sendbuf_max=4194304  # (default 2097152)
net.inet.tcp.recvbuf_max=4194304  # (default 2097152) #2097152 is fine for most networks.
# Servers with threading software apache2 / Pound may want to rise following sysctl
kern.threads.max_threads_per_proc=4096 #1500
#net.inet.ip.fw.dyn_max=65535
#net.inet.udp.sendspace=65535
#net.inet.ipf.fr_tcpidletimeout=864000
#net.inet.tcp.inflight.enable=1
#net.inet.tcp.rfc1644=1
# This should be enabled if you going to use big spaces (>64k)
# Also timestamp field is useful when using syncookies
#net.inet.tcp.rfc1323=1 #default is on
#net.inet.tcp.rfc3042=1 #default is on
#net.inet.tcp.rfc3390=1 #default is on
EOF

echo -e "\033[1;40;31mInfo:	@$ETC_PATH/sysctl.conf Add the following lines:\033[0m" | tee -a $LOGFILE
tail -n 46 $ETC_PATH/sysctl.conf | tee -a $LOGFILE

fi

echo "-----------------------add $ETC_PATH/sysctl.conf proc log end---------------------" | tee -a $LOGFILE
echo "Ⅰ==================================== $ETC_PATH/sysctl.conf ===========================================" | tee -a $LOGFILE
