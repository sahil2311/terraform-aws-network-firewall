resource "aws_ram_resource_share" "aws_ram_resource_share" {
  name                      = "${var.environment}-tgw-share-01"
  allow_external_principals = true
  tags = {
    Name = "${var.environment}-tgw-share-01"
  }
}

resource "aws_ram_resource_association" "aws_ram_resource_association" {
  resource_arn       = aws_ec2_transit_gateway.aws_ec2_transit_gateway.arn
  resource_share_arn = aws_ram_resource_share.aws_ram_resource_share.arn
}

resource "aws_ram_principal_association" "aws_ram_principal_association" {
  for_each           = toset(var.share_tgw_account_ids)
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.aws_ram_resource_share.arn
}
