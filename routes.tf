resource "aws_route" "aws_route" {
  depends_on             = [aws_route_table.aws_route_table_public, aws_subnet.aws_subnet_public, aws_subnet.aws_subnet_inspection, aws_ec2_transit_gateway.aws_ec2_transit_gateway, aws_ec2_transit_gateway_vpc_attachment.aws_ec2_transit_gateway_vpc_attachment_ingress]
  for_each               = toset(var.external_vpc_ip_cidr)
  route_table_id         = aws_route_table.aws_route_table_public.id
  destination_cidr_block = each.value
  transit_gateway_id     = aws_ec2_transit_gateway.aws_ec2_transit_gateway.id
  lifecycle {
    ignore_changes = [destination_cidr_block]
  }
}