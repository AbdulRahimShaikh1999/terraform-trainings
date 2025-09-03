provider "aws" {
  region = "us-east-1"
}

# Caller identity (account ID, user ID, ARN)
data "aws_caller_identity" "me" {}

# Current AWS region
data "aws_region" "current" {}


# Return full caller identity info
output "aws_caller_identity" {
  value = data.aws_caller_identity.me
}

# Return current AWS region
output "aws_region" {
  value = data.aws_region.current.name
}
