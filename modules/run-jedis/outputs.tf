


output "jedis-failover-ansible-playbook-cmd" {
  description = "jedis ansible-playbook cmd"
  value = format("ansible-playbook %s/ansible//%s_jedis_playbook.yaml --private-key %s -i /tmp/%s_test_node_%s.ini",path.module, var.vpc_name, var.ssh_key_path, var.vpc_name, 0)

}