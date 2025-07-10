terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

resource "aws_route" "aws_route" {
  depends_on             = [aws_route_table.aws_route_table_public, aws_ec2_transit_gateway.aws_ec2_transit_gateway]
  for_each               = toset(var.aws_vpc_cidr)
  route_table_id         = aws_route_table.aws_route_table_public.id
  destination_cidr_block = each.value
  transit_gateway_id     = aws_ec2_transit_gateway.aws_ec2_transit_gateway.id
}