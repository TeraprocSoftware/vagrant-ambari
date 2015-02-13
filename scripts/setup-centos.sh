	#!/bin/bash
source "/vagrant/scripts/common.sh"

function disableFirewall {
	echo "disabling firewall"
	service iptables save
	service iptables stop
	chkconfig iptables off
}


function installUtilities {
	echo "install utilities"
	yum install -y wget
    yum install -y nc
    yum install -y zip
}

function enableNTPD {
    echo "enable ntpd"
    yum install -y ntp
    service ntpd start
}

echo "setup centos"

disableFirewall
installUtilities
enableNTPD