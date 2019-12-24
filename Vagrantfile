# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # 
  # Online documentation https://docs.vagrantup.com.

  config.vm.box = "jasonc/centos7"
  #config.vm.box = "centos/7"
  config.vm.provider "virtualbox" do |vb|

	#
	# Add disk volumes into the machine  
	#

	file_to_disk = './large_disk.vdi'
	
	unless File.exist?('file_to_disk')
		vb.customize ['createhd', '--filename', file_to_disk, '--size', 2 * 1024]
	end
	
	file_to_disk2 = './disk_2.vdi'
	
	unless File.exist?('file_to_disk2')
		vb.customize ['createhd', '--filename', file_to_disk2, '--size', 2 * 1024]
	end
	
	vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--type', 'hdd', '--port', 1, '--device', 0, '--medium', file_to_disk]
	vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--type', 'hdd', '--port', 2, '--device', 0, '--medium', file_to_disk2]
  
  
  end 
 
  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  
end
