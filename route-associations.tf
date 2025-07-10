resource "aws_route_table_association" "aws_route_table_association_public" {
  count          = length(var.aws_cidrs_public)
  subnet_id      = element(aws_subnet.aws_subnet_public[*].id, count.index)
  route_table_id = aws_route_table.aws_route_table_public.id
}

resource "aws_route_table_association" "aws_route_table_association_inspection" {
  count          = length(var.aws_cidrs_inspection)
  subnet_id      = element(aws_subnet.aws_subnet_inspection[*].id, count.index)
  route_table_id = aws_route_table.aws_route_table_inspection.id
}

resource "aws_route_table_association" "aws_route_table_association_tgw" {
  depends_on     = [aws_networkfirewall_firewall.aws_networkfirewall_firewall]
  count          = length(var.aws_cidrs_tgw)
  subnet_id      = element(aws_subnet.aws_subnet_tgw[*].id, count.index)
  route_table_id = element(aws_route_table.aws_route_table_tgw[*].id, count.index)
}