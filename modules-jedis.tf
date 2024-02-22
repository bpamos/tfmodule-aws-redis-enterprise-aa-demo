

#### Create Test nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "nodes-config-jedis-1" {
    source             = "./modules/nodes-config-jedis"
    providers = {
      aws = aws.a
    }
    ssh_key_name           = var.ssh_key_name1
    ssh_key_path           = var.ssh_key_path1
    test-node-count        = var.test-node-count
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name               = module.vpc1.vpc-name
    vpc_id                 = module.vpc1.vpc-id
    aws_eips               = module.nodes-tester1.node-eips
    crdb_endpoint_cluster1 = module.create-crdbs.crdb_endpoint_cluster1
    crdb_endpoint_cluster2 = module.create-crdbs.crdb_endpoint_cluster2
    crdb_port              = var.crdb_port
    crdb_db_password       = var.crdb_db_password

    depends_on = [
      module.nodes-tester1,
      module.nodes-config-redisoss-1,
      module.create-crdbs
    ]
}

output "mvn_command1" {
  value = module.nodes-config-jedis-1.mvn_command
}

#### Create Test nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "run-jedis1" {
    source             = "./modules/run-jedis"
    providers = {
      aws = aws.a
    }
    test-node-count           = var.test-node-count
    vpc_name                  = module.vpc1.vpc-name
    ssh_key_path              = var.ssh_key_path1
    mvn_command               = module.nodes-config-jedis-1.mvn_command

    depends_on = [
      module.nodes-tester1,
      module.nodes-config-redisoss-1,
      module.nodes-config-jedis-1
    ]
}

output "jedis-failover-ansible-playbook-cmd1" {
  value = module.run-jedis1.jedis-failover-ansible-playbook-cmd
}