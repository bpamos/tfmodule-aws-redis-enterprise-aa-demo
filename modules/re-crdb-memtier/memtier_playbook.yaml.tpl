---

- hosts: all
  become: yes
  become_user: root
  become_method: sudo
  gather_facts: yes

  tasks:
    - name: memtier data load cmd
      command: "${memtier_data_load_cluster} -s ${crdb_endpoint_cluster} -p ${crdb_port}"