resource "aws_vpc" "vpc" {
  cidr_block           = var.aws_vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  tags = {
    Name = "vpc-${var.environment}-eks"
  }
}

resource "aws_eip" "eip" {
  tags = {
    Name = "${var.environment}-nat-eip"
  }
}

resource "aws_internet_gateway" "aws_internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_nat_gateway" "aws_nat_gateway" {
  depends_on    = [aws_internet_gateway.aws_internet_gateway]
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.aws_subnet_public[0].id
  tags = {
    Name = "${var.environment}-nat-gw"
  }
}

resource "aws_subnet" "aws_subnet_public" {
  count                   = length(var.aws_cidrs_public)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.aws_cidrs_public, count.index)
  availability_zone       = element(local.aws_azs, count.index)
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.environment}-public-subnet-${element(local.aws_azs, count.index)}"
  }
}

resource "aws_subnet" "aws_subnet_inspection" {
  count             = length(var.aws_cidrs_inspection)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.aws_cidrs_inspection, count.index)
  availability_zone = element(local.aws_azs, count.index)
  tags = {
    Name = "${var.environment}-inspection-subnet-${element(local.aws_azs, count.index)}"
  }
}

resource "aws_subnet" "aws_subnet_tgw" {
  count             = length(var.aws_cidrs_tgw)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.aws_cidrs_tgw, count.index)
  availability_zone = element(local.aws_azs, count.index)
  tags = {
    Name = "${var.environment}-tgw-subnet-${element(local.aws_azs, count.index)}"
  }
}