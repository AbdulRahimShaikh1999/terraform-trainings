provider "aws" {
  region = "us-east-1"
}


data "aws_caller_identity" "me" {}


data "aws_region" "current" {}



output "aws_caller_identity" {
  value = data.aws_caller_identity.me
}


output "aws_region" {
  value = data.aws_region.current.name
}

####

# A data source block (lookup an existing VPC by default filter)
data "aws_vpc" "consoleVPC" {
  filter {
  name   = "tag:Env"
  values = ["Production"]
}

}

# Output the ID of the looked-up VPC
output "non_default_vpc_id" {
  value = data.aws_vpc.consoleVPC.id
}
