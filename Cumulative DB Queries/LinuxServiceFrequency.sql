SELECT
--	mn.machineName,
	sfn.FileName,
	ls.description, count(*) as cnt

FROM
	[dbo].[mocLinuxServices] AS [ls] WITH(NOLOCK)
	INNER JOIN [dbo].[machines] AS [mn] WITH(NOLOCK) ON ([mn].[PK_Machines] = [ls].[FK_Machines])
	INNER JOIN [dbo].[LinuxMachineModulePaths] AS [mp] WITH(NOLOCK) ON ([mp].[PK_LinuxMachineModulePaths] = [ls].[FK_LinuxMachineModulePaths])
	--INNER JOIN [dbo].[LinuxModules] AS [mo] WITH(NOLOCK) ON ([mo].[PK_LinuxModules] = [mp].[FK_LinuxModules])
	INNER JOIN [dbo].[FileNames] AS [sfn] WITH(NOLOCK) ON ([sfn].[PK_FileNames] = [mp].[FK_FileNames])

Group by sfn.filename, ls.Description
order by cnt desc

	/*
where 
	mn.MachineName like 'xsj-silicon66'
order by sfn.FileName
*/





--//sample output


/* FileName	description	cnt
nwe-agent	 Starts nwe agent 	1860
snmpd	 start and stop Net-SNMP daemon	1587
snmptrapd	 start and stop Net-SNMP trap daemon	1587
saslauthd	 Start/Stop the SASL authentication daemon	1587
rdisc	 This is a daemon which discovers routers on the local subnet.	1587
automount	 Automounts filesystems on demand	1587
reboot		1587
atd	 Starts/stop the "at" daemon	1586
crond	 run cron daemon	1586
dbus-daemon	 The D-Bus systemwide message bus	1586
auditd	 This starts the Linux Auditing System Daemon, \#              which collects security related events in a dedicated \#       	1586
nscd	 Starts the Name Switch Cache Daemon	1583
restorecond	restorecond uses inotify to look for creation of new files \# listed in the /etc/selinux/restorecond.conf file, and restores t	1581
ntpdate	 set the date and time via NTP	1581
ntpd	 start and stop ntpd	1581
portreserve	 Port reservation utility	1581
rngd	 This starts the Random Number Generator Daemon, \#              which collects entropy from hardware sources and \#          	1578
svnserve	 start and stop the svnserve daemon	1577
smartd	 Self Monitoring and Reporting Technology (SMART) Daemon	1577
irqbalance	 start and stop irqbalance daemon 	1577
quota_nld	 Disk quota netlink message daemon	1577
acpid	 start and stop acpid	1576
abrtd	 Saves segfault data, kernel oopses, fatal exceptions	1564
httpd	 start and stop Apache HTTP Server	1560
htcacheclean	 start and stop htcacheclean	1560
rhnsd	 Starts the Red Hat Network Daemon	1540
wdaemon	 helps X.org to support Wacom tablets hotplugging by creating \#    permanent uinput devices that may be feeded by real tablets	1517
spice-vdagentd	 Agent daemon for Spice guests	1517
dnsmasq	 This script starts your DNS caching server# processname: dnsmasq# pidfile: /var/run/dnsmasq.pid# Source function library..	1437
wpa_supplicant	 start and stop wpa_supplicant	1432
slapd	 starts and stopd OpenLDAP server daemon	1392
sshd	 Start up the OpenSSH server daemon	1387
pcscd	 Daemon to access a smart card using PC/SC	1374
hald	  This is a daemon for collecting and maintaing information \#               about hardware from several sources. \#          	1361
xinetd	 start and stop xinetd	1359
nslcd	 naming services LDAP client daemon	1285
postfix	 start and stop postfix	1124
pppoe-server	  pppoe-server is a user-space server for PPPoE (Point-to-Point Protocol over Eth- \#               ernet) for Linux and other 	808
BESClient	 Starts and stops the IBM Endpoint Manager Client daemon# processname: BESClientexport SYSTEMCTL_SKIP_REDIRECT=1# Source fu	765
rpcbind	 The rpcbind utility is a server that converts RPC program \#              numbers into universal addresses. It must be running	711
rpc.statd	 Start up the NFS file locking sevice	679
rpc.gssd	 Starts the RPCSEC GSS client daemon	664
nimbus	 NimBUS Robot	648
rpc.svcgssd	 Start up the NFS server sevice	643
rsyslogd	 Enhanced system logging and kernel message trapping daemons	617
cupsd	 The CUPS scheduler	614
rpc.idmapd	 Starts the NFSv4 id mapping daemon	607
rpc.svcgssd	 Starts the RPCSEC GSS server daemon	604
master	 start and stop postfix	516
ruby	 Start daemon at boot time	469
ruby	 Enables periodic system configuration checks through puppet.# processname: puppet# config: /etc/sysconfig/puppet# Source fu	438
pxp-agent-1.2.2	 Agent for the PCP Execution Protocol (PXP), based on#              the Puppet Communications Protocol (PCP).# processname: px	432
rhsmcertd	  Enable periodic update of entitlement certificates.# processname:  rhsmsertd#### BEGIN INIT INFO# Provides:       rhsmcert	298
sssd	 System Security Services Daemon	286
lim	  Load Sharing Facility## The following is for the Linux insserv utility### BEGIN INIT INFO# Provides: lsf# Required-Start:	219
sendmail.sendmail	 start and stop sendmail	195
avahi-daemon	 Starts the Avahi Daemon	184
multipathd	 Control multipathd	184
ypbind	 This is a daemon which runs on NIS/YP clients and binds them \#              to a NIS domain. It must be running for systems b	159
certmonger	 Certificate monitor and PKI enrollment client	136
rhnsd	 Starts the Spacewalk Daemon	107
ctxcdmd	 Citrix Client Drive Mapping for Linux	88
ctxpolicyd	 Citrix Policy service for Linux	73
ctxcupsd	 Citrix CUPS for Linux	68
ctxhdx	 Citrix HDX for Linux	64
ctxvhcid	 Citrix USB VHCI service for Linux	63
ctxusbsd	 Citrix USB service for Linux	62
ctxceip	 Citrix CEIP service for Linux	47
php-fpm	 start and stop PHP FPM	46
ctxlogd	 ctxlogd	43
bash	 Citrix Virtual Desktop Agent for Linux	42
rhsmcertd	  Enable periodic update of entitlement certificates.# processname:  rhsmsertd## source function library. /etc/rc.d/init.d/	39
postgres	 PostgreSQL database server.# processname: postmaster# pidfile: /var/run/postmaster.PORT.pid# This script is slightly unusua	35
mcelog	mcelog hardware error logging	14
memcached	The memcached daemon is a network memory cache service.# processname: memcached# config: /etc/sysconfig/memcached# pidfile: 	12
mongod	 Mongo is a scalable, document-oriented database.# processname: mongod# config: /etc/mongod.conf. /etc/rc.d/init.d/functions	10
collectd	 Collectd is a statistics gathering daemon used to collect \#   system information ie. cpu, memory, disk, network# processname	9
nrpe	 nrpe is a daemon for a remote nagios server, \#              running nagios plugins on this host.# processname: nrpe# config	8
erunnerd	 Electric Runner	8
postgres	 PostgreSQL database server.# processname: postmaster# pidfile="/var/run/${NAME}.pid"# This script is slightly unusual in th	7
textmlserver4	 Textmlserver (Ixiasoft Inc.)## source function library. /etc/init.d/functions# uncomment next line to turn debug on#set	5
named	 start|stop|status|restart|try-restart|reload|force-reload DNS server	5
mysqld	 start and stop MySQL server	4
mongod	 Mongo is a scalable, document-oriented database.# processname: mongod# config: /etc/mongod.conf# pidfile: /var/run/mongodb/m	4
abrt-dump-oops	 Watches system log for oops messages, creates ABRT dump directories for each oops	3
dsm_om_connsvcd	 DSM OM Connection Service	3
dsm_om_shrsvcd	 DSM OM Shared Services	3
dnscrypt-proxy	 dnscrypt-proxy	3
ipmievd	 ipmievd daemon to send events to syslog	3
dsm_sa_datamgrd	 Systems Management Data Engine	3
iprdump	 Start the ipr dump daemon	3
Xvfb	 Xvfb server daemon## processname: Xvfb# see Oracle Metalink Note 181244.1# "Configuring VNC Or XVFB As The X Server For Ap	3
iscsid	 Starts and stops login iSCSI daemon.	3
iprupdate	 Start the iprupdate utility	3
iprinit	 Start the ipr init daemon	3
mosquitto	 Mosquitto MQTT broker	3
ebtables	 Ethernet Bridge filtering tables## config: /etc/sysconfig/ebtables         (text)#         /etc/sysconfig/ebtables.<table> (	3
dhcrelay	 Start and stop the DHCP relay server	2
dhcpd	 Start and stop the DHCP server	2
dhcpd	 Start and stop the DHCPv6 server	2
kprop	 start and stop the Kerberos 5 propagation client	2
krb5kdc	 start and stop the Kerberos 5 KDC	2
java	 Jenkins Continuous Integration Server	2
mongos	 Mongo is a scalable, document-oriented database.# processname: mongos# config: /etc/mongos.conf. /etc/rc.d/init.d/functions	2
numad	 numad control	2
nginx-debug	 start and stop nginx	2
dhcrelay	 Start and stop the DHCP relay server for IPv6	2
tcsd	 TrouSerS server daemon## processname: tcsd# config: /etc/tcsd.conf# pidfile: /var/run/tcsd.pid## Return values according 	2
java	 Jenkins Automation Server	2
ipa_kpasswd	 ipa_kpasswd IPA Kpasswd daemon# processname: /usr/sbin/ipa_kpasswd# configdir:   /etc/sysconfig/ipa-kpasswd## Source funct	1
nagios	 Nagios network monitor## File : nagios## Author : Jorge Sanchez Aymar (jsanchez@lanchile.cl)# # Changelog :## 1999-07-0	1
nginx	 start and stop nginx	1
oddjobd	 start and stop oddjob services	1
rpc.rstatd	 start and stop rpc.rstatd	1
rwhod	 start and stop rwhod	1
cachefilesd	 Control the persistent network fs caching service	1
gpm	 Start and stop gpm daemon	1
ecagent	 start and stop postfix	1
amtu	  This service runs the abstract machine tests to check the \#underlying security assumptions. It can be configured to#hal	1
BESClient	 Starts and stops the IBM BigFix Client daemon# processname: BESClientexport SYSTEMCTL_SKIP_REDIRECT=1# Source function lib	1
dnscrypt-proxy	     SEcure DNS ssl proxy, initscript made by Dju	1
pkcsslotd	 pkcsslotd is a daemon which manages cryptographic hardware \# tokens for the openCryptoki package.. /etc/init.d/functionsP	1
postgres	 PostgreSQL database server.# processname: postmaster# pidfile: /var/run/postmaster-8.4.pid# This script is slightly unusual	1
bmc-watchdog	 Start and stop bmc-watchdog	1
ipmidetectd	 Start and stop ipmidetectd	1
squid	 starting and stopping Squid Internet Object Cache	1
smbd	 Starts and stops the Samba smbd and nmbd daemons \#       used to provide SMB network services.## pidfile: /var/run/samba/s	1
uuidd	 UUID daemon	1
python2.7	 advocate server. /etc/init.d/functionsRTM_TOP=/opt/IBMRETVAL=0prog='advocate'user='advocate'group='advocate'default_po	1
openhpid	 Start OpenHPI daemon at boot time	1
mip6d	 Start and stop Mobile IPV6 daemon	1
ipmiseld	 Start and stop ipmidetectd	1
watchdog	 A watchdog daemon## rc file author: Marc Merlin <marcsoft@merlins.org>#                 Henning P. Schmiedehausen <hps@tanst	1
mysql	MySQL database server.# processname: mysqld# config: /etc/my.cnf# pidfile: /var/run/mysqld/mysqld.pid# Source function lib	1
hpiSubagent	 Start HPI SNMP Subagent at boot time	1
keepalived	 High Availability monitor built upon LVS and VRRP	1
mysqld	MySQL database server.# processname: mysqld# config: /etc/my.cnf# pidfile: /var/run/mysqld/mysqld.pidsu - foundryb -c "/et	1 */