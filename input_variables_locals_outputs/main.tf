variable "aws_region" {
#   description = "The AWS region to deploy resources in"
#   type        = string
#   default     = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical (official Ubuntu account)
}


resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-EC2"
  }
}


###


variable "ec2_instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro", "t3.large"], var.ec2_instance_type)
    error_message = "Only t2.micro and t3.micro instances are supported"
  }
}

variable "ec2_volume_type" {
  description = "The type of EBS volume to attach to the EC2 instance (e.g., gp2, gp3, io1)"
  type        = string
  default     = "gp2"
}

variable "ec2_volume_size" {
  description = "The size of the EBS root volume in GiB"
  type        = number
  default     = 8
}

data "aws_ami" "ubuntu2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical (official Ubuntu account)
}

resource "aws_instance" "instance_from_variables" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type

  root_block_device {
    volume_type = var.ec2_volume_type
    volume_size = var.ec2_volume_size
    delete_on_termination = true
  }

  tags = {
    Name = "Terraform-EC2-instance"
  }
}
