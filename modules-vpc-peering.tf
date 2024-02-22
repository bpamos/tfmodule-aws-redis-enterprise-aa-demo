# ######
# #### VPC Peering Modules
# #### VPC peering is broken into 2 modules because you need to 
# #### request from region A (provider A), and accept from region B (provider B)
# #### Final step is to do a route table association to the VPC peering ID

# #### VPC peering requestor from region A (VPC A) to region B (VPC B)
# module "vpc-peering-requestor" {
#     source             = "./modules/vpc-peering-requestor"
#     providers = {
#       aws = aws.a
#     }
#     peer_region        = var.region2
#     main_vpc_id        = module.vpc1.vpc-id
#     peer_vpc_id        = module.vpc2.vpc-id
#     vpc_name1          = module.vpc1.vpc-name
#     vpc_name2          = module.vpc2.vpc-name
#     owner              = var.owner

#     depends_on = [
#       module.vpc1, module.vpc2
#     ]
# }

# #### output the vpc peering ID to use in acceptor module
# output "vpc_peering_connection_id" {
#   description = "VPC peering connection ID"
#   value = module.vpc-peering-requestor.vpc_peering_connection_id
# }

# #### VPC peering acceptor, accept from region B (VPC B) to region A (VPC A)
# module "vpc-peering-acceptor" {
#     source             = "./modules/vpc-peering-acceptor"
#     providers = {
#       aws = aws.b
#     }
#     vpc_peering_connection_id = module.vpc-peering-requestor.vpc_peering_connection_id

#     depends_on = [
#       module.vpc1, module.vpc2, module.vpc-peering-requestor
#     ]
# }

# #### Route table association in reigon A (VPC A) for vpc peering id to VPC CIDR in Region B
# module "vpc-peering-routetable1" {
#     source             = "./modules/vpc-peering-routetable"
#     providers = {
#       aws = aws.a
#     }
#     peer_vpc_id               = module.vpc2.vpc-id
#     main_vpc_route_table_id   = module.vpc1.route-table-id
#     vpc_peering_connection_id = module.vpc-peering-requestor.vpc_peering_connection_id
#     peer_vpc_cidr             = var.vpc_cidr2

#     depends_on = [
#       module.vpc1, 
#       module.vpc2, 
#       module.vpc-peering-requestor,
#       module.vpc-peering-acceptor
#     ]
# }
