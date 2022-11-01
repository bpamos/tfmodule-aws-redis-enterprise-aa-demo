#### Required Variables

# variable "owner" {
#     description = "owner tag name"
# }

variable "main_region" {
    description = "AWS region"
}

variable "peer_region" {
    description = "AWS region"
}

# variable "vpc_name1" {
#     description = "vpc name 1"
# }

# variable "vpc_name2" {
#     description = "vpc name 2"
# }

variable "main_vpc_id" {
  description = "The ID of the VPC"
  default = ""
}

variable "peer_vpc_id" {
  description = "The ID of the VPC"
  default = ""
}

variable "vpc_peering_connection_id" {
  description = ".."
  default = ""
}

