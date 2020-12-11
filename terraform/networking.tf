# AZs ######################################

# Declare a data source for available azs
data "aws_availability_zones" "available" {
  state = "available"
}

# VPCs #####################################

# base VPC for deployment
resource "aws_vpc" "heimdall_vpc" {
  cidr_block       = "${var.vpc_cidr_first_16}.0.0/16"

  tags = {
    Name   = "${var.proj_name}-heimdall-vpc"
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.heimdall_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.heimdall_vpc_ig.id  # see IGWs below
}

# SUBNETS ##################################

# Create a subnet to launch our instances into
resource "aws_subnet" "heimdall_main_subnet" {
  vpc_id                  = aws_vpc.heimdall_vpc.id
  cidr_block              = "${var.vpc_cidr_first_16}.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.proj_name}-heimdall-main-subnet"
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
}

# Create a backup subnet to launch our instances into
resource "aws_subnet" "heimdall_backup_subnet" {
  vpc_id                  = aws_vpc.heimdall_vpc.id
  cidr_block              = "${var.vpc_cidr_first_16}.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.proj_name}-heimdall-backup-subnet"
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
}

# Create a subnet to launch our RDS into zone A
resource "aws_subnet" "heimdall_rds_subnet_a" {
  vpc_id                  = aws_vpc.heimdall_vpc.id
  cidr_block              = "${var.vpc_cidr_first_16}.3.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  #map_public_ip_on_launch = true

  tags = {
    Name    = "${var.proj_name}-heimdall-rds-privsubnet-a"
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
}

# Attach a private route table to the above subnet
resource "aws_route_table_association" "heimdall_rds_subnet_a_priv_rt" {
    subnet_id = aws_subnet.heimdall_rds_subnet_a.id
    route_table_id = aws_route_table.private_rt_no_nat.id
}

# Create a subnet to launch our RDS into zone B
resource "aws_subnet" "heimdall_rds_subnet_b" {
  vpc_id                  = aws_vpc.heimdall_vpc.id
  cidr_block              = "${var.vpc_cidr_first_16}.4.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  #map_public_ip_on_launch = true

  tags = {
    Name    = "${var.proj_name}-heimdall-rds-privsubnet-b"
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
}

# Attach a private route table to the above subnet
resource "aws_route_table_association" "heimdall_rds_subnet_b_priv_rt" {
    subnet_id = aws_subnet.heimdall_rds_subnet_b.id
    route_table_id = aws_route_table.private_rt_no_nat.id
}

# SG #######################################
# see the security_groups.tf

# IGWs #####################################

# Create an internet gateway for that VPC
resource "aws_internet_gateway" "heimdall_vpc_ig" {
  vpc_id = aws_vpc.heimdall_vpc.id

  tags = {
    Name    = "${var.proj_name}-heimdall-vpc"
    Owner   = "${var.your_name}"
    Project = "${var.proj_name}"
  }
}

# Do Not grant the VPC internet access on its private route table
resource "aws_route_table" "private_rt_no_nat" {
  vpc_id = aws_vpc.heimdall_vpc.id

  tags = {
  name    = "${var.proj_name}-heimdall-private-rt-no-nat"
  Owner   = "${var.your_name}"
  Project = "${var.proj_name}"
  }
}
