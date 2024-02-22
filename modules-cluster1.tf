########## Active Active Db Redis Enterprise Clusters between 2 regions (Cluster 1) #####
#### Modules to create the following:
#### Brand new VPC in region A
#### VPC peering requestor from region A to VPC in region B
#### VPC peering acceptor from region B to region A
#### Route table VPC peering id association for VPC A
#### Cluster A, RE nodes and install RE software (ubuntu)
#### VPC A, Test node with Redis and Memtier
#### Cluster A, DNS (NS and A records for RE nodes)
#### Cluster A, Create and Join RE cluster
#### Create CRDB DB between Cluster A & Cluster B
#### Run Memtier benchmark data load and benchmark cmd from tester node in VPC A to Cluster A


########### VPC Module
#### create a brand new VPC, use its outputs in future modules
#### If you already have an existing VPC, comment out and
#### enter your VPC params in the future modules
module "vpc1" {
    source             = "./modules/vpc"
    providers = {
      aws = aws.a
    }
    aws_creds          = var.aws_creds
    owner              = var.owner
    region             = var.region1
    base_name          = var.base_name1
    vpc_cidr           = var.vpc_cidr1
    subnet_cidr_blocks = var.subnet_cidr_blocks1
    subnet_azs         = var.subnet_azs1
}

### VPC outputs 
### Outputs from VPC outputs.tf, 
### must output here to use in future modules)
output "subnet-ids1" {
  value = module.vpc1.subnet-ids
}

output "vpc-id1" {
  value = module.vpc1.vpc-id
}

output "vpc_name1" {
  description = "get the VPC Name tag"
  value = module.vpc1.vpc-name
}

output "route-table-id1" {
  description = "route table id"
  value = module.vpc1.route-table-id
}

########### Security Group Module
#### create a security group
module "security-group1" {
    source             = "./modules/security-group"
    providers = {
      aws = aws.a
    }
    owner              = var.owner
    vpc_cidr           = var.vpc_cidr1
    allow-public-ssh   = var.allow-public-ssh
    open-nets          = var.open-nets
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.vpc1.vpc-name
    vpc_id             = module.vpc1.vpc-id

    depends_on = [
      module.vpc1
    ]
}

output "aws_security_group_id1" {
  description = "aws security group"
  value = module.security-group1.aws_security_group_id
}

# ########### DNS Module
# #### Create DNS (NS record, A records for each RE node and its eip)
# #### Currently using existing dns hosted zone
# module "dns1" {
#     source             = "./modules/dns"
#     providers = {
#       aws = aws.a
#     }
#     dns_hosted_zone_id = var.dns_hosted_zone_id
#     data-node-count    = var.data-node-count
#     ### vars pulled from previous modules
#     vpc_name           = module.vpc1.vpc-name
#     re-data-node-eips  = module.nodes-re1.node-eips
# }

# #### dns FQDN output used in future modules
# output "dns-ns-record-name1" {
#   value = module.dns1.dns-ns-record-name
# }
