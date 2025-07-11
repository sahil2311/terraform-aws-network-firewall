output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "public_subnets" {
  value = aws_subnet.aws_subnet_public.*.id
}

output "public_subnets_cidr" {
  value = aws_subnet.aws_subnet_public.*.cidr_block
}

output "inspection_subnets_azs" {
  value = aws_subnet.aws_subnet_inspection.*.id
}

output "inspection_subnets" {
  value = aws_subnet.aws_subnet_inspection.*.id
}

output "inspection_subnets_arn" {
  value = aws_subnet.aws_subnet_inspection.*.arn
}

output "inspection_subnets_cidr" {
  value = aws_subnet.aws_subnet_inspection.*.cidr_block
}

output "tgw_subnets" {
  value = aws_subnet.aws_subnet_tgw.*.id
}

output "tgw_subnets_cidr" {
  value = aws_subnet.aws_subnet_tgw.*.cidr_block
}

output "tgw_id" {
  value = aws_ec2_transit_gateway.aws_ec2_transit_gateway.id
}

output "availability_zone" {
  value = local.aws_azs
}