####################################
########### Node Module
#### Create Test nodes
#### Create the test nodes and their associated infra
#### configure them and install RE in the config module.
module "nodes-tester1" {
    source             = "./modules/nodes"
    providers = {
      aws = aws.a
    }
    owner              = var.owner
    region             = var.region1
    vpc_cidr           = var.vpc_cidr1
    subnet_azs         = var.subnet_azs1
    ssh_key_name       = var.ssh_key_name1
    ssh_key_path       = var.ssh_key_path1
    node-count         = var.test-node-count
    node-prefix        = var.node-prefix-tester
    ec2_instance_type  = var.test_instance_type
    #ebs-volume-size    = var.re-volume-size
    create_ebs_volumes = var.create_ebs_volumes_tester
    ### vars pulled from previous modules
    security_group_id  = module.security-group1.aws_security_group_id
    ## from vpc module outputs 
    vpc_name           = module.vpc1.vpc-name
    vpc_subnets_ids    = module.vpc1.subnet-ids
    vpc_id             = module.vpc1.vpc-id

    depends_on = [
      module.vpc1,
      module.security-group1
    ]
}

#### Node Outputs to use in future modules
output "test-node-eips1" {
  value = module.nodes-tester1.node-eips
}

output "test-node-internal-ips1" {
  value = module.nodes-tester1.node-internal-ips
}

output "test-node-eip-public-dns1" {
  value = module.nodes-tester1.node-eip-public-dns
}


# #### Create Test nodes
# #### Ansible playbooks configure Test node with Redis and Memtier
# module "nodes-config-redisoss-1" {
#     source             = "./modules/nodes-config-redisoss"
#     providers = {
#       aws = aws.a
#     }
#     ssh_key_name       = var.ssh_key_name1
#     ssh_key_path       = var.ssh_key_path1
#     test_instance_type = var.test_instance_type
#     test-node-count    = var.test-node-count
#     ### vars pulled from previous modules
#     ## from vpc module outputs 
#     vpc_name           = module.vpc1.vpc-name
#     vpc_id             = module.vpc1.vpc-id
#     aws_eips           = module.nodes-tester1.node-eips

#     depends_on = [
#       module.nodes-tester1
#     ]
# }


#### Deploy front end on test node
#### Ansible playbooks configure Test node with front end
module "nodes-deploy-frontend1" {
    source             = "./modules/nodes-frontend"
    providers = {
      aws = aws.a
    }
    ssh_key_name       = var.ssh_key_name1
    ssh_key_path       = var.ssh_key_path1
    test-node-count    = var.test-node-count
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.vpc1.vpc-name
    vpc_id             = module.vpc1.vpc-id
    aws_eips           = module.nodes-tester1.node-eips

    depends_on = [
      module.nodes-tester1,
      #module.nodes-config-redisoss-1
    ]
}