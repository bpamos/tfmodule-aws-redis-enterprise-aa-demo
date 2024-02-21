---
- hosts: all
  become: yes
  become_user: root
  become_method: sudo
  gather_facts: yes

  tasks:
    - name: Extract and run mvn command
      ansible.builtin.shell:
        cmd: |
          cd /tmp/jedis-failover-demo/
          {{ jedis_cmd | regex_replace('EOT', '') }}
      vars:
        jedis_cmd: ${jedis_cmd}
      register: mvn_output

    - debug:
        msg: "{{ item }}"
      with_items: "{{ mvn_output.stdout_lines }}"