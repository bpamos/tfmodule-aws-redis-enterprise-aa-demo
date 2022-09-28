terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
      configuration_aliases = [ aws.a, aws.b ]
    }
  }
}

#### AWS region and AWS key pair
provider "aws" {
  alias      = "a"
  region     = var.region1
  access_key = var.aws_creds[0]
  secret_key = var.aws_creds[1]
}

provider "aws" {
  alias      = "b"
  region     = var.region2
  access_key = var.aws_creds[0]
  secret_key = var.aws_creds[1]
}