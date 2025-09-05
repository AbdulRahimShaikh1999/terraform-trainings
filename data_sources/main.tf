terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}






data "aws_caller_identity" "me" {}


data "aws_region" "current" {}



# output "aws_caller_identity" {
#   value = data.aws_caller_identity.me
# }


# output "aws_region" {
#   value = data.aws_region.current.name
# }

####

# A data source block (lookup an existing VPC by default filter)
data "aws_vpc" "consoleVPC" {
  filter {
  name   = "tag:Env"
  values = ["Production"]
}

}

# Output the ID of the looked-up VPC
# output "non_default_vpc_id" {
#   value = data.aws_vpc.consoleVPC.id
# }

data "aws_availability_zones" "available" {}

# Output the list of AZ names
# output "az_names" {
#   value = data.aws_availability_zones.available
# }


###

# Create IAM policy document using the data source
data "aws_iam_policy_document" "s3_read_all" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::*",
      "arn:aws:s3:::*/*",
    ]
  }
}

# Output JSON-formatted policy
output "s3_read_all_policy" {
  value = data.aws_iam_policy_document.s3_read_all.json
}

###

# IAM policy document for static website access
data "aws_iam_policy_document" "static_website" {
  statement {
    sid = "PublicReadGetObject"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:GetObject"]

    resources = ["arn:aws:s3:::*/*"]
  }
}

# Output the generated IAM policy JSON
output "iam_policy" {
  value = data.aws_iam_policy_document.static_website.json
}