data "aws_vpc" "selected" {
  id = var.vpc_id
}

#Declare the subnet in the existing VPC us-east-2 region
data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

#Declare the ubuntu latest image
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

  owners = ["099720109477"]
}

# Declare the data source
data "aws_availability_zones" "azs" {
  state = "available"
}
