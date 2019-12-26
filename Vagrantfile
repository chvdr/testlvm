# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "jasonc/centos7"

  config.vm.provider "virtualbox" do |vb|

	#
	# ADD DISK VOLUMES INTO THE MACHINE  
	#

	file_to_disk = './large_disk.vdi'
	
	unless File.exist?(file_to_disk)
		vb.customize ['createhd', '--filename', file_to_disk, '--size', 2 * 1024]
	end
	
	file_to_disk2 = './disk_2.vdi'
	
	unless File.exist?(file_to_disk2)
		vb.customize ['createhd', '--filename', file_to_disk2, '--size', 2 * 1024]
	end
	
	vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--type', 'hdd', '--port', 1, '--device', 0, '--medium', file_to_disk]
	vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--type', 'hdd', '--port', 2, '--device', 0, '--medium', file_to_disk2]
  
  
  end 
 
  # 
  # PROVISION
  # 
	config.vm.provision "shell", inline: <<-SHELL
	
	echo -e "** PROVISION IS TO BEGIN **"

		# create new disk 
		echo -e "-- creating /dev/sdb1 and /dev/sdc1 using FDISK --"
		echo -e 'n\n\n\n\n\nt\n8e\nw' | fdisk /dev/sdb > /dev/null
		echo -e 'n\n\n\n\n\nt\n8e\nw' | fdisk /dev/sdc > /dev/null

		# create PVs
		echo -e "-- creating PVs -- "
		pvcreate /dev/sdb1 
		pvcreate /dev/sdc1 
		#
		# Extend the VG 
		echo -e "-- Extending the VG  --"
		vgcreate dbadata /dev/sdb1 /dev/sdc1 
		
		# Extend lv 1022 extents is the whole added space ~4GB (2x(2GB, each PV))
		echo -e "-- Creating lv  --"
		lvcreate -l 1022 -n backup1_lv dbadata
		
		# Create EXT4 file system over the Linux Volume 
		echo -e "-- mkfs.ext4 /dev/dbadata/backup1_lv --"
		mkfs.ext4 /dev/dbadata/backup1_lv
		
		# Resize FS 
		echo -e "-- Resizing FS  --"
		resize2fs /dev/dbadata/backup1_lv
		
		# Edit FSTAB
		echo -e "-- Editing FSTAB --"
		mkdir /backups
		echo `blkid /dev/dbadata/backup1_lv | awk '{print$2}' | sed -e 's/"//g'` /backups   ext4   noatime,nobarrier   0   0 >> /etc/fstab
        mount /backups
		
		echo -e "-- creating testing file [/backups/README] --"
		echo -e "mkdir -p /backups/testfolder/"
		mkdir -p /backups/testfolder/
		
		echo "history > /backups/README"
		echo '
		WELCOME TO YOUR NEW EMPTY LINUX BOX!
				
		Author:
		Chavdar Georgiev, Experian SSC UNIX support
		
		NOTE: 
		To revert FS type of backups, simply execute:
		/vagrant/revert.sh
		
		Of course you may compare the output of df -hT before and after that
		Enjoy!
		
		2019 (c). Experian [$(date)]
		
		' > /backups/README
		
		echo "cat /backups/README"
		cp /backups/README /backups/testfolder/README
		
		cat /backups/testfolder/README

	SHELL
  
end
