# vagrant_ambari
Vagrant project to spin up a cluster of 6 virtual machines with HDP2.2 deployed.


# Introduction

Vagrant project to spin up a cluster of 6 virtual machines with pre-installed Ambari 1.7 and pre-downloaed HDP 2.2, then automatically install and deploy HDP with predefined blueprint that set up the following cluster:

1. node1 : HDFS NameNode + Zookeeper Server + Ganglia Monitor
2. node2 : HDFS Secondary NameNode + YARN ResourceManager + JobHistoryServer + AppTimelineServer + Zookeeper Server + HBase Master + Nagio Server + Ganglia Server + Ganglia Monitor
3. node3 : HDFS DataNode + YARN NodeManager + HBase RegionServer + Zookeeper Client + HBase Client + HDFS Client + YARN Client + Slider + Mapreduce2 Client + Ganglia Monitor
4. node4 : HDFS DataNode + YARN NodeManager + HBase RegionServer + Ganglia Monitor
5. node5 : HDFS DataNode + YARN NodeManager + HBase RegionServer + Ganglia Monitor
6. node6 : HDFS DataNode + YARN NodeManager + HBase RegionServer + Ganglia Monitor

# Getting Started

**Warning:** Do *not* modify the ```numNodes``` value in the Vagrant file. The default ambari blueprint assumes there are 6 nodes in the cluster.

1. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads).
2. [Download and install Vagrant](http://www.vagrantup.com/downloads.html).
3. [Download](https://drive.google.com/uc?export=download&id=0B6bkZyioajrYa0FIMGIySUNDRzg) the ```centos65-ambari-hdp.box``` vagrant box to local host. This box has Ambari 1.7 preinstalled and HDP 2.2 pre-downloaded. This box also has **20 GB** of dynamic disk configured. The size of the box file is 2.16GB.
4. Run ```vagrant box add centos65-ambari-hdp centos65-ambari-hdp.box```.
5. Run ```vagrant box list``` to confirm that the ```centos65-ambari-hdp``` vagrant box has been added to vagrant.
6. Git clone this project, and change directory (cd) into this project (directory).
7. Run ```vagrant up``` to create the VM.
8. Log on to the [Ambari server](http://10.211.55.101:8080) to view the progress of the HDP2.2 deployment.
9. The ip of VMs are 10.211.55.101, ...., 10.211.55.106.
10. Run ```vagrant destroy``` when you want to destroy and get rid of the VM.
11. The directory of /vagrant is mounted in each VM by vagrant if you want to access host machine from VM. You could also use win-sshfs if you want to access the local file system of VM from host machine. Please refer to http://code.google.com/p/win-sshfs/ for details.

Some gotcha's.

* Make sure you download Vagrant v1.7.1 or higher and VirtualBox 4.3.20 or higher with extension package
* Make sure when you clone this project, you preserve the Unix/OSX end-of-line (EOL) characters. The scripts will fail with Windows EOL characters. If you are using Windows, please make sure the following configuration is configured in your .gitconfig file which is located in your home directory ("C:\Users\yourname" in Win7 and after, and "C:\Documents and Settings\yourname" in WinXP). Refer to http://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration for details of git configuration.
```
[core]
    autocrlf = false
    safecrlf = true
```
* Make sure you have 10Gb of free memory for the VMs. You may change the Vagrantfile to specify smaller memory requirements.
* This project has NOT been tested with the other providers such as VMware for Vagrant.
* You may change the script (common.sh) to point to a different location for Hadoop, Zookeeper .... to be downloaded from. 

# Install and provision HDP 2.2 cluster from vanilla centos6.5 vagrant box

If you do not wish to use the vagrant box that we have created with pre-installed Ambari and pre-downloaded HDP packages, you can choose to spin up 6 virtual machines with the vanilla centos6.5 vagrant box, and follow these steps to install and provision an HDP 2.2 cluster. Please note that this will take significantly longer time as the Ambari server will need to download the necessary HDP packages first on each node. Also note that sometimes this approach may not work as too many connections to the HDP repo will probably cause the connection to timeout.

1. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads).
2. [Download and install Vagrant](http://www.vagrantup.com/downloads.html).
3. Run ```vagrant box add centos65 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box```. This is a minimal centos6.5 vagrant box obtained from [here](https://github.com/2creatives/vagrant-centos/releases/tag/v6.5.3).
4. Run ```vagrant box list``` to confirm that the ```centos65``` vagrant box has been added to vagrant.
5. Git clone this project, and change directory (cd) into this project (directory).
6. Backup the original ``Vagrantfile`` (for example, rename ``Vagrantfile`` to ``Vagrantfile.orig``).
7. Copy the ``Vagrantfile_hdp_install_setup`` to ``Vagrantfile``.
8. Run ```vagrant up``` to create the VM.
9. Log on to the [Ambari server](http://10.211.55.101:8080) to view the progress of the HDP2.2 deployment.
10. The ip of VMs are 10.211.55.101, ...., 10.211.55.106.
11. Run ```vagrant destroy``` when you want to destroy and get rid of the VM.

# Vagrant boxes
A list of available Vagrant boxes can be accessed [here](http://www.vagrantbox.es). 

# Vagrant box location
The Vagrant box is downloaded to the ```~/.vagrant.d/boxes``` directory. On Windows, this is ```C:/Users/{your-username}/.vagrant.d/boxes```.

# Steps to create the ``centos65-ambari-hdp.box`` vagrant box
As a reference, follow these steps to create a vagrant box with pre-installed Ambari 1.7 and pre-downloaded HDP 2.2 with 20GB of dynamic disk:

* Spin up a virtual machine with vagrant using [this](https://github.com/2creatives/vagrant-centos/releases/tag/v6.5.3) vagrant box.
* Expand this virtual box disk to 20GB (default 8GB) by doing the following:
  * Run ``vagrant halt`` to shutdown the virtual machine.
  * Run ``"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" clonehd "box-disk1.vmdk" "clone-disk1.vdi" --format vdi`` to clone the main disk.
  * Run ``"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyhd "clone-disk1.vdi" --resize 20480`` to resize the disk to 20GB.
  * Start up the VBoxManage GUI, remove the original vmdk, and attach the new vdi: ``Settings -> Storage -> Controller: SATA -> Right click remove box-disk1.vmdk and then attach clone-disk1.vdi``.
  * Download GParted ISO from: http://gparted.sourceforge.net/download.php, and attach GParted ISO to the storage: ``Settings -> Storage -> Controller: SATA -> Right click and Add CD/DVD to attach the GParted ISO``.
  * Modify ``Settings -> Motherboard -> Boot order`` to boot from ISO.
  * Hit ``Enter, Enter, ...`` until the GParted GUI is displayed, and resize the disk to maximum. Apply and save the changes.
  * Shutdown the virtual machine from the VBoxManage GUI.
  * Unmount the ISO from the VBoxManage GUI.
  * Restart the virtual machine from the VBoxManage GUI.
  * Close the VBoxManage GUI.
* SSH into the virtual machine. Run ``df`` to verify that the maximum storage is 20GB.
* Run the following commands to install Ambari 1.7:
  *	``wget -nv http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.7.0/ambari.repo -O /etc/yum.repos.d/ambari.repo``.
  * ``yum install -y ambari-server ambari-agent``.
* Run the following commands to pre-download HDP 2.2 into yum cache:
  * ``wget -nv http://public-repo-1.hortonworks.com/HDP/centos6/2.x/GA/2.2.0.0/hdp.repo -O /etc/yum.repos.d/HDP.repo``.
  * ``yum install -y yum-plugin-downloadonly``.
  * ``yum install -y --downloadonly hadoop_2_2_* slider_2_2_* storm_2_2_* hadoop_2_2_*-yarn hadoop_2_2_*-mapreduce snappy snappy-devel hadoop_2_2_*-libhdfs ambari-log4j httpd python-rrdtool-1.4.5 libganglia-3.5.0-99 ganglia-devel-3.5.0-99 ganglia-gmetad-3.5.0-99 ganglia-web-3.5.7-99.noarch ganglia-gmond-3.5.0-99 ganglia-gmond-modules-python-3.5.0-99 hbase_2_2_* hive_2_2_* mysql mysql-server extjs oozie_2_2_* pig_2_2_* sqoop_2_2_* tez_2_2_* fping nagios-plugins-1.4.9 nagios-3.5.0-99 nagios-www-3.5.0-99 nagios-devel-3.5.0-99``.
* Run ``su - vagrant`` to change user to ``vagrant``.
* Edit ``/home/vagrant/.ssh/authorized_keys`` and replace the key with the [default insecure key](https://github.com/mitchellh/vagrant/blob/master/keys/vagrant.pub).
* Note: If you have set up a private network in the box with ``eth1``, make sure to delete the following file ``/etc/sysconfig/network-scripts/ifcfg-eth1``.
* Run ``vagrant halt`` to shutdown the virtual machine.
* Run ``vagrant package --base <hostname> --output centos65-ambari-hdp.box`` to generate the vagrant box.
 

# Copyright Stuff
Copyright 2015

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

