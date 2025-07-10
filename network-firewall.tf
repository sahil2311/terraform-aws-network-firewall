resource "aws_networkfirewall_firewall" "aws_networkfirewall_firewall" {
  depends_on               = [time_sleep.wait_300_seconds]
  name                     = "${var.environment}-network-firewall"
  firewall_policy_arn      = aws_networkfirewall_firewall_policy.aws_networkfirewall_firewall_policy.arn
  vpc_id                   = aws_vpc.vpc.id
  subnet_change_protection = true

  dynamic "subnet_mapping" {
    for_each = toset(aws_subnet.aws_subnet_inspection[*].id)
    content {
      subnet_id = subnet_mapping.value
    }
  }

  timeouts {
    create = "40m"
    update = "50m"
    delete = "1h"
  }
}

resource "time_sleep" "wait_180_seconds" {
  depends_on       = [aws_route.aws_route]
  create_duration  = "300s"
  destroy_duration = "120s"
}

resource "time_sleep" "wait_300_seconds" {
  destroy_duration = "300s"
}