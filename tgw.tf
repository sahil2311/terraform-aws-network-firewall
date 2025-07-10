resource "aws_ec2_transit_gateway" "aws_ec2_transit_gateway" {
  depends_on                      = [aws_subnet.aws_subnet_inspection, aws_subnet.aws_subnet_public, aws_subnet.aws_subnet_tgw]
  description                     = "${var.environment}-tgw"
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  tags = {
    Name = "${var.environment}-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "aws_ec2_transit_gateway_vpc_attachment_ingress" {
  transit_gateway_id = aws_ec2_transit_gateway.aws_ec2_transit_gateway.id
  vpc_id             = aws_vpc.vpc.id
  subnet_ids         = aws_subnet.aws_subnet_tgw.*.id
  tags = {
    Name = "${var.environment}-vpc-att-tgw"
  }
}

resource "aws_ec2_transit_gateway_route" "aws_ec2_transit_gateway_route" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.aws_ec2_transit_gateway_vpc_attachment_ingress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.aws_ec2_transit_gateway.association_default_route_table_id
}