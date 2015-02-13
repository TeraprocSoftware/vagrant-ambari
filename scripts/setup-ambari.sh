#!/bin/bash
source "/vagrant/scripts/common.sh"

ACTION=install
SERVER=node1
HOSTNUM=6

while getopts a:m: option
do
	case "${option}"
	in
		a) ACTION=${OPTARG};;
		m) SERVER=${OPTARG};;
	esac
done

function installAmbariAgent {
	wget -nv http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.7.0/ambari.repo -O /etc/yum.repos.d/ambari.repo
    wget -nv http://public-repo-1.hortonworks.com/HDP/centos6/2.x/GA/2.2.0.0/hdp.repo -O /etc/yum.repos.d/HDP.repo	
	yum install -y ambari-agent
}

function installAmbariServer {
	yum install -y ambari-server
}

function setupAmbariServer {
	echo "Setup Ambari Server"
	ambari-server setup --silent
	chkconfig ambari-server on
	ambari-server start
}

function deployAmbariCluster {
	echo "Deploy Ambari Cluster"
	cp /vagrant/resources/ambari/deploy-teraproc-cluster.sh /tmp/	
	cp /vagrant/resources/blueprints/teraproc-default-blueprint.json /tmp/
	cp /vagrant/resources/blueprints/TeraprocTestCluster.json /tmp/	
	cd /tmp ; /tmp/deploy-teraproc-cluster.sh
}

function setupAmbariAgent {
	ambari-server stop
	chkconfig ambari-server off
	ambari-agent stop
	sed -i "s/^hostname=.*/hostname=$SERVER/" /etc/ambari-agent/conf/ambari-agent.ini
	cp /vagrant/resources/ambari/internal-hostname.sh /etc/ambari-agent/conf/	
	sed -i "/\[agent\]/ a hostname_script=\/etc\/ambari-agent\/conf\/internal-hostname.sh" /etc/ambari-agent/conf/ambari-agent.ini
	ambari-agent start	
}

function enableNtpd {
	chkconfig ntpd on
}

case "$ACTION" in 
	install-agent)
		echo "Install Ambari Agent"
		installAmbariAgent
		;;
	install-server)
		echo "Install Ambari Server"
		installAmbariServer
		;;
	setup-server)
		echo "Setup Ambari Server"
		setupAmbariServer
		;;
	setup-agent)
		echo "Setup Ambari Agent"
		enableNtpd		
		setupAmbariAgent
		;;
	deploy-cluster)
		echo "Deploy Ambari Cluster"
		deployAmbariCluster
		;;
esac	