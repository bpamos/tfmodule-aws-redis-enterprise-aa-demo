#### Required Variables

# variable "aws_creds" {
#     description = "Access key and Secret key for AWS [Access Keys, Secret Key]"
# }

# variable "main_region" {
#     description = "AWS region"
# }

# variable "peer_region" {
#     description = "AWS region"
# }
# # variable "owner" {
# #     description = "owner tag name"
# # }

# variable "main_vpc_id" {
#   description = "The ID of the VPC"
#   default = ""
# }

variable "peer_vpc_id" {
  description = "The ID of the VPC"
  default = ""
}

variable "peer_vpc_cidr" {
  description = "The VPC CIDR of the peer VPC"
  default = ""
}

variable "main_vpc_route_table_id" {
  description = "The main vpc route table id"
  default = ""
}

variable "vpc_peering_connection_id" {
  description = ".."
  default = ""
}