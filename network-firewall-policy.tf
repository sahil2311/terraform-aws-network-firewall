locals {
  managed_rule_group_arns = [
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesPhishingActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesSuspectActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/AbusedLegitMalwareDomainsActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesEmergingEventsActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesExploitsActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareWebActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesIOCActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareCoinminingActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesScannersActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/BotNetCommandAndControlDomainsActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesDoSActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesWebAttacksActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/MalwareDomainsActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetWebActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesFUPActionOrder"
  ]
  managed_rules = var.attached_stateful_managed_rules_only ? local.managed_rule_group_arns : var.attached_stateful_custom_rules_only ? concat([aws_networkfirewall_rule_group.block_domains[0].arn, aws_networkfirewall_rule_group.block_public_dns_resolvers[0].arn]) : concat([managed_rule_group_arns, aws_networkfirewall_rule_group.block_domains[0].arn, aws_networkfirewall_rule_group.block_public_dns_resolvers[0].arn])
}

resource "aws_networkfirewall_firewall_policy" "aws_networkfirewall_firewall_policy" {
  depends_on = [var.attached_stateless_icmp_blocked_rule, aws_networkfirewall_rule_group.block_domains, aws_networkfirewall_rule_group.block_public_dns_resolvers]
  name       = "${var.environment}-network-policy"
  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    dynamic "stateless_rule_group_reference" {
      for_each = var.attached_stateless_icmp_blocked_rule ? toset([aws_networkfirewall_rule_group.drop_icmp[0].arn]) : toset([])
      content {
        priority     = 20
        resource_arn = stateless_rule_group_reference.value
      }
    }
    dynamic "stateful_rule_group_reference" {
      for_each = local.managed_rules
      content {
        resource_arn = stateful_rule_group_reference.value
      }
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}