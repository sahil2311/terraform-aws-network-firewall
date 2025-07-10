resource "aws_networkfirewall_rule_group" "drop_icmp" {
  count    = var.attached_stateless_icmp_blocked_rule ? 1 : 0
  capacity = 1
  name     = "drop-icmp-${var.environment}"
  type     = "STATELESS"
  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        stateless_rule {
          priority = 1
          rule_definition {
            actions = ["aws:drop"]
            match_attributes {
              protocols = [1]
              source {
                address_definition = "0.0.0.0/0"
              }
              destination {
                address_definition = "0.0.0.0/0"
              }
            }
          }
        }
      }
    }
  }
}

resource "aws_networkfirewall_rule_group" "block_public_dns_resolvers" {
  count    = var.attached_stateful_custom_rules_only ? 1 : 0
  capacity = 1
  name     = "block-public-dns-${var.environment}"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      stateful_rule {
        action = "DROP"
        header {
          destination      = "ANY"
          destination_port = "ANY"
          direction        = "ANY"
          protocol         = "DNS"
          source           = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword  = "sid"
          settings = ["50"]
        }
      }
    }
  }
}

resource "aws_networkfirewall_rule_group" "block_domains" {
  count       = var.attached_stateful_custom_rules_only ? 1 : 0
  name        = "${var.environment}-stateful-domain-list"
  description = "Stateful rule group to block access to specific domains"
  capacity    = 100
  type        = "STATEFUL"
  rule_group {
    rules_source {
      rules_source_list {
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        targets              = ["www.faceboot.com"]
        generated_rules_type = "ALLOWLIST"
      }
    }
  }
}