resource "aws_route_table" "aws_route_table_public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_internet_gateway.id
  }
  tags = {
    Name = "${var.environment}-public-route"
  }
  lifecycle {
    ignore_changes = [route]
  }
}

resource "aws_route_table" "aws_route_table_inspection" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.aws_nat_gateway.id
  }
  tags = {
    Name = "${var.environment}-inspection-route"
  }
}

resource "aws_route_table" "aws_route_table_tgw" {
  count  = length(var.aws_cidrs_tgw)
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.environment}-tgw-route-${count.index + 1}"
  }
}

resource "aws_route" "aws_route_tgw" {
  depends_on             = [aws_route_table.aws_route_table_tgw, aws_networkfirewall_firewall.aws_networkfirewall_firewall]
  count                  = length(var.aws_cidrs_tgw)
  route_table_id         = aws_route_table.aws_route_table_tgw[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = flatten([for state in aws_networkfirewall_firewall.aws_networkfirewall_firewall.firewall_status : [for sync in state.sync_states : [for attach in sync.attachment : attach.endpoint_id]]])[count.index]
}