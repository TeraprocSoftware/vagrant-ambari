Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	numNodes = 6
	r = numNodes..1
	(r.first).downto(r.last).each do |i|
		config.vm.define "node-#{i}" do |node|
			node.vm.box = "centos65-ambari-hdp"
			# ===================================================================================================================
			# The URL from which to download the vagrant box (with pre-installed Ambari 1.7 and pre-downloaded HDP 2.2, and 
			# 20GB dynamic disk) if it is not already downloaded:
			# https://drive.google.com/uc?export=download&id=0B6bkZyioajrYa0FIMGIySUNDRzg
			# Warning: This file is 2.16 GB, it must be downloaded from a web browser first, as google drive
			# enforce viruses scan confirmation.
			# After downloading, run the following command to add the vagrant box:
			# vagrant box add centos65-ambari-hdp centos65-ambari-hdp.box 
			# ===================================================================================================================			
			node.vm.provider "virtualbox" do |v|
			    v.name = "node#{i}"			
			    v.customize ["modifyvm", :id, "--memory", "2048"]
			end
     		node.vm.network :private_network, ip: "10.211.55.10#{i}"
			node.vm.hostname = "node#{i}"	
			node.vm.provision "shell", path: "scripts/setup-centos.sh"
			node.vm.provision "shell" do |s|
				s.path = "scripts/setup-centos-hosts.sh"
				s.args = "-t #{numNodes}"
			end
			node.vm.provision "shell" do |s|
				s.path = "scripts/setup-ambari.sh"
				s.args = "-a setup-agent -m node1"
			end
			if i == 1
			    # I am the server			
				node.vm.provision "shell" do |s|
					s.path = "scripts/setup-ambari.sh"
					s.args = "-a setup-server"
				end
				# Now that the Ambari server has started, deploy the blueprint and create the HDP cluster				
				node.vm.provision "shell" do |s|
					s.path = "scripts/setup-ambari.sh"
					s.args = "-a deploy-cluster"
				end				
			end
		end
	end
end