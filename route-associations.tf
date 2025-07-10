resource "aws_route_table_association" "aws_route_table_association_public" {
  count          = length(var.aws_cidrs_public)
  subnet_id      = aws_subnet.aws_subnet_public[*].id[count.index]
  route_table_id = aws_route_table.aws_route_table_public[*].id[count.index]
}

resource "aws_route_table_association" "aws_route_table_association_inspection" {
  count          = length(var.aws_cidrs_inspection)
  route_table_id = aws_route_table.aws_route_table_inspection.id
  subnet_id      = aws_subnet.aws_subnet_inspection[*].id[count.index]
}

resource "aws_route_table_association" "aws_route_table_association_tgw" {
  count          = length(var.aws_cidrs_tgw)
  route_table_id = aws_route_table.aws_route_table_tgw[count.index].id
  subnet_id      = aws_subnet.aws_subnet_inspection[*].id[count.index]
}