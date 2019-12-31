#!/bin/bash

# Project name: 
# Tarnsfer sensitive data from EXT4 to XFS FS 

# The plan: 
# * Reduce the running FS (it is EXT4);
# * Create new XFS FS using unleashed space; 
# * Sync/Copy data from /backups to /backups_NEW
# * Destroy EXT4 FS and use the space to extend XFS (backups_NEW)

# I. GETTING SPACE FROM THE EXISTING EXT4 VG/LV 

# [1]. Gather info
# vgdisplay dbadata
# ls -latr /backups/ 	# <must see test.txt>
# lvs 
# lvscan

# [2]. Un-mount and check 
umount /backups/
# e2fsck -vy /dev/mapper/dbadata-backup1_lv
# e2fsck -f /dev/mapper/dbadata-backup1_lv
# <"0.0% non-contiguous" is what we expect to see here>

# [3]. Reduce LV 
lvdisplay /dev/dbadata/backup1_lv
e2fsck -f /dev/mapper/dbadata-backup1_lv
# TO DO: add check here ############### RC2 ###############
if [[ ! $(resize2fs /dev/dbadata/backup1_lv 1G) ]]; then echo -e "FAIL: resize2fs /dev/dbadata/backup1_lv 1G"; fi							
lvdisplay /dev/dbadata/backup1_lv
echo -e "y\n" | lvreduce /dev/dbadata/backup1_lv --size 1G		
# lvreduce /dev/dbadata/backup1_lv --size 1G
lvdisplay /dev/dbadata/backup1_lv
# <Expected result: "LV Size 1.00 GiB">

# [4]. Reduce VG 
vgreduce dbadata /dev/sdc1

# [5]. Extend FS over new amount of space
e2fsck -fy /dev/dbadata/backup1_lv
resize2fs /dev/dbadata/backup1_lv

# II. CREATING NEW XFS DRIVE

# [6]. Create new VG (with LV on it) 
vgcreate dbdata_NEW /dev/sdc1

# [7]. Create XFS on new LV 
lvcreate -l 500 -n backup2_lv dbdata_NEW
mkfs.xfs /dev/mapper/dbdata_NEW-backup2_lv

# III. Move data from EXT4 to XFS 
mkdir /backups_NEW
mount /dev/mapper/dbdata_NEW-backup2_lv /backups_NEW
mount /dev/mapper/dbadata-backup1_lv /backups
rsync -zavh /backups/* /backups_NEW
ls -altr /backups_NEW
cat /backups/README 

# IV. Remove /backups (VG and content)
umount /backups_NEW
umount /backups
echo -e "y\ny\n" | vgremove dbadata
# vgremove dbadata

# V. Extend "/backups_NEW" with PV "/dev/sdb1", resize LV 
vgextend dbdata_NEW /dev/sdb1
lvextend -l +100%FREE /dev/mapper/dbdata_NEW-backup2_lv || 
#  xfs_growfs -n /dev/dbdata_NEW/backup2_lv to see the status 
# xfs_growfs /dev/dbdata_NEW/backup2_lv ATTN: ON MOUNTED FS!!!

# VI. Fix /etc/fstab and recoot to check this out (this is manual context and will not take place here)
sed -i '/backups/s/^/#/g' /etc/fstab 
echo `blkid /dev/mapper/dbdata_NEW-backup2_lv | awk '{print$2}' | sed -e 's/"//g'` /backups   xfs   noatime,nobarrier   0   0 >> /etc/fstab
mount -a 
xfs_growfs /dev/dbdata_NEW/backup2_lv

exit 0
