- Restarting ceph processes using systemctl on ubuntu:

     ```
    systemctl restart ceph-osd@*
    systemctl restart ceph-mon@*
    systemctl restart ceph-mgr@*
    systemctl restsrt ceph-radosgw@*
   ```      
- Running a commnad on group of hosts in inventory file using ceph-ansible:

   `ceph-ansible <groupname> -i inventory -m shell -a 'uptime'
   `
   
   ```  
     ceph-ansible osds -i inventory -m shell -a 'systemctl restart ceph-osd@*'
     ceph-ansible osds -i inventory -m shell -a 'systemctl restart ceph-mon@*'
     ceph-ansible osds -i inventory -m shell -a 'systemctl restart ceph-mgr@*'
     ceph-ansible osds -i inventory -m shell -a 'systemctl restart ceph-radosgw@*'
     ```
 
- Running a 
playbook on inventory and fork parallael instances (more than default) using ceph-ansible-playbook:

  `ceph-ansible-playbook -i inventory -f 24 -e @envname/vars.yml benchmark/fio_benchmark.yml `

- how to rgw benchmark:
`ceph-ansible-playbook -i inventory  -e @envname/vars.yml benchmark/rgw_benchmark.yml`
 Add following lines to the vars.yml:
 
 ```
 external_lb_vip_address: "{{ bootstrap_host_public_address | default(ansible_default_ipv4.address) }}"
 internal_lb_vip_address: <ip address of haproxy node>
 
 ``` 
 
- how to print env variables used by a process in linux:

  `cat /proc/<pid>/environ`

- readelf of a binary (which memory allocator in use
  ` readelf -d `which ceph-osd` | grep malloc ` 
- NUMA autobalancing is enabled by default: `cat /proc/sys/kernel/numa_balancing` 
- Setting this numa_balacing values to 1 or 0 enables/disables the feature.
- When dealing with 2 NUMA zones autobalancing should be good enough.
- To manually configure a process to a NUMA zone, it has to be started with numactl. 
- `https://github.com/RHsyseng/hci/blob/master/custom-templates/numa-systemd-osd.sh` provides details on how to make sure ceph-osd node's NIC and osd processes are in the same NUMA zone.
- `numad` is another option to look into. 
- RedHat Performance tuning guide:
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html-single/performance_tuning_guide/index
- Hyper converged ceph: 
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/11/html/hyper-converged_infrastructure_guide/resource-isolation

- ceph osd config show: `ceph --admin-daemon /var/run/ceph/ceph-osd.0.asok config show` 
- ceph osd perf dump: `ceph --admin-daemon /var/run/ceph/ceph-osd.0.asok perf dump` or `ceph daemon osd.0 perf dump`
Setting up prometheus/node_exporter
https://www.digitalocean.com/community/tutorials/how-to-install-prometheus-on-ubuntu-16-04
- Need to do grafana as well.

- osd removal:

  ```
  for i in {0..11}; do ceph osd crush remove osd.$i; ceph auth del osd.$i; ceph osd rm $i; done
  ceph-ansible osds -i inventory -m shell -a 'systemctl stop ceph-osd@*'
  ceph-ansible osds -i inventory -m shell -a 'umount /dev/nvme*'
  ceph-ansible osds -i inventory -m shell -a 'rm -rf /var/lib/ceph/osd'
  ceph-ansible osds -i inventory -m shell -a 'sgdisk -Z /dev/nvme0n1'
  ceph-ansible osds -i inventory -m shell -a 'sgdisk -Z /dev/nvme1n1'
  dd if=/dev/zero of=/dev/nvme0n1 bs=1M oflag=direct
  dd if=/dev/zero of=/dev/nvme1n1 bs=1M oflag=direct
  ceph-ansible osds -i inventory -m shell -a 'hdparm -tT --direct /dev/nvme0n1'
  ceph-ansible osds -i inventory -m shell -a 'hdparm -tT --direct /dev/nvme1n1'
  ceph-ansible osds -i inventory -m shell -a 'dd if=/dev/zero of=/dev/nvme1n1 bs=1M oflag=direct' // To dd'ing whole disk
  
  ```
  
 - rados bench runs: 
    ```
    rados bench -p <poolname> 300 write -t 8 -b 4K
    rados bench -p <poolname> 300 write --concurrent-ios=32 -b 4K
    ```
    
 - list current tunables:
    
     ```
     root@ceph:/etc/ceph# ceph osd crush show-tunables
{
    "choose_local_tries": 0,
    "choose_local_fallback_tries": 0,
    "choose_total_tries": 50,
    "chooseleaf_descend_once": 1,
    "chooseleaf_vary_r": 1,
    "chooseleaf_stable": 1,
    "straw_calc_version": 1,
    "allowed_bucket_algs": 54,
    "profile": "jewel",
    "optimal_tunables": 1,
    "legacy_tunables": 0,
    "minimum_required_version": "jewel",
    "require_feature_tunables": 1,
    "require_feature_tunables2": 1,
    "has_v2_rules": 0,
    "require_feature_tunables3": 1,
    "has_v3_rules": 0,
    "has_v4_buckets": 1,
    "require_feature_tunables5": 1,
    "has_v5_rules": 0
}

root@ceph:/etc/ceph# 
```
