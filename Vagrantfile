# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # 
  # Online documentation https://docs.vagrantup.com.

  # config.vm.box = "jasonc/centos7"
  config.vm.box = "centos/7"
  config.vm.provider "virtualbox" do |vb|

	#
	# Add disk volumes into the machine  
	#
	
	# VBoxManage clonemedium [disk|dvd|floppy] <uuid|inputfile> <uuid|outputfile>
	# [--format VDI|VMDK|VHD|RAW|<other>]
	# [--variant Standard,Fixed,Split2G,Stream,ESX]
	# [--existing]

	
	unless File.exist?('./secondDisk.vhd')
		vb.customize ['createhd', '--filename', './secondDisk.vhd', '--format', 'VHD' , '--variant', 'Fixed', '--size', 8 * 1024]
	end
	#unless File.exist?('./thirdDisk.vhd')
	#	vb.customize ['createhd', '--filename', './thirdDisk.vhd', '--variant', 'Fixed', '--size', 8 * 1024]
	#end
	# vb.memory = "2048"
	vb.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', './secondDisk.vhd']
	#vb.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', './thirdDisk.vdi']

  end
 
  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  
end
