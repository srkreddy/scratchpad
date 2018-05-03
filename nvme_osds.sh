echo "partition the two nvme disks"
for num in {0..1}; do
sgdisk -Z /dev/nvme${num}n1
done
sleep 10
 parted /dev/nvme0n1 mklabel gpt
 parted -a optimal /dev/nvme0n1 mkpart primary 1 20G
 parted -a optimal /dev/nvme0n1 mkpart primary 20G 40G
 parted -a optimal /dev/nvme0n1 mkpart primary 40G 51%
 parted -a optimal /dev/nvme0n1 mkpart primary 51% 100%
sleep 10
sudo mkfs -t xfs -f -i size=2048 /dev/nvme0n1p3
sudo mkfs -t xfs -f -i size=2048 /dev/nvme0n1p4

sleep 5

 parted /dev/nvme1n1 mklabel gpt
 parted -a optimal /dev/nvme1n1 mkpart primary 1 20G
 parted -a optimal /dev/nvme1n1 mkpart primary 20G 40G
 parted -a optimal /dev/nvme1n1 mkpart primary 40G 51%
 parted -a optimal /dev/nvme1n1 mkpart primary 51% 100%
sleep 10
 mkfs -t xfs -f -i size=2048 /dev/nvme1n1p3
 mkfs -t xfs -f -i size=2048 /dev/nvme1n1p4

echo "Creatting and activating osds"


ceph-disk prepare --cluster ceph --cluster-uuid 8f042892-20f6-4655-bad4-5e88ce769d29  --fs-type xfs --crush-device-class NVME --filestore /dev/nvme0n1p3 /dev/nvme0n1p1
sudo chown ceph:ceph /dev/nvme0n1p1
sudo chown ceph:ceph /dev/nvme0n1p3
ceph-disk activate /dev/nvme0n1p3


ceph-disk prepare --cluster ceph --cluster-uuid 8f042892-20f6-4655-bad4-5e88ce769d29  --fs-type xfs --crush-device-class NVME --filestore /dev/nvme0n1p4 /dev/nvme0n1p2
sudo chown ceph:ceph /dev/nvme0n1p2
sudo chown ceph:ceph /dev/nvme0n1p4
ceph-disk activate /dev/nvme0n1p4

ceph-disk prepare --cluster ceph --cluster-uuid 8f042892-20f6-4655-bad4-5e88ce769d29  --fs-type xfs --crush-device-class NVME --filestore /dev/nvme1n1p3 /dev/nvme1n1p1
sudo chown ceph:ceph /dev/nvme1n1p1
sudo chown ceph:ceph /dev/nvme1n1p3
ceph-disk activate /dev/nvme1n1p3

ceph-disk prepare --cluster ceph --cluster-uuid 8f042892-20f6-4655-bad4-5e88ce769d29  --fs-type xfs --crush-device-class NVME --filestore /dev/nvme1n1p4 /dev/nvme1n1p2
sudo chown ceph:ceph /dev/nvme1n1p2
sudo chown ceph:ceph /dev/nvme1n1p4
ceph-disk activate /dev/nvme1n1p4
