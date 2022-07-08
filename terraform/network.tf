resource "aws_key_pair" "bootstrap-key" {
  key_name   = "key-${var.environment}"
  public_key = var.bootstrap_key
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.infra}-${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.infra}-${var.environment}-igw"
  }
}

resource "aws_nat_gateway" "nat-gw" {

  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.dmz.*.id[0]
  tags = {
    Name = "${var.infra}-${var.environment}-nat-gw"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat-eip" {

  vpc = true
  tags = {
    Name = "${var.infra}-${var.environment}-nat-eip}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"

}