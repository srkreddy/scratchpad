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

