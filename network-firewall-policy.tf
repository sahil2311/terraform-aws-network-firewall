locals {
  managed_rule_group_arns = [
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesPhishingActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesSuspectActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/AbusedLegitMalwareDomainsActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesEmergingEventsActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesExploitsActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareWebActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesIOCActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareCoinminingActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesScannersActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/BotNetCommandAndControlDomainsActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesDoSActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesWebAttacksActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareMobileActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/MalwareDomainsActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetWebActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetWindowsActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareActionOrder",
    "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesFUPActionOrder"
  ]
  managed_rules = var.attached_stateful_managed_rules ? local.managed_rule_group_arns : concat([aws_networkfirewall_rule_group.block_domains[0].arn, aws_networkfirewall_rule_group.block_public_dns_resolvers[0].arn])
}

resource "aws_networkfirewall_firewall_policy" "aws_networkfirewall_firewall_policy" {
  name = "${var.environment}-network-policy"
  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateless_rule_group_reference {
      priority     = 20
      resource_arn = aws_networkfirewall_rule_group.drop_icmp.arn
    }
    dynamic "stateful_rule_group_reference" {
      for_each = local.managed_rules
      content {
        resource_arn = stateful_rule_group_reference.value
      }
    }
  }
}