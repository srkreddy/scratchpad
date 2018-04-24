- Restarting ceph processes using systemctl on ubuntu:

     ```
    systemctl restart ceph-osd@*
    systemctl restart ceph-mon@*
    systemctl restart ceph-mgr@*
   ```      
- Running a commnad on group of hosts in inventory file using ceph-ansible:

   `ceph-ansible <groupname> -i inventory -m shell -a 'uptime' `
 
- Running a benchmark playbook on inventory and fork parallael instances (more than default) using ceph-ansible-playbook:

  `ceph-ansible-playbook -i inventory -f 24 -e @dirname/vars.yml benchmark/fio_benchmark.yml `

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
- ceph osd perf dump: `ceph --admin-daemon /var/run/ceph/ceph-osd.0.asok perf dump`
- 
