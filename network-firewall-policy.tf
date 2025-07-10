locals {
  managed_rule_group_arns = concat([aws_networkfirewall_rule_group.block_domains.arn, aws_networkfirewall_rule_group.block_public_dns_resolvers.arn],
    [
      "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesPhishingActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/AbusedLegitBotNetCommandAndControlDomainsActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesSuspectActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesExploitsStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesScannersStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/BotNetCommandAndControlDomainsStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/AbusedLegitMalwareDomainsActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesEmergingEventsActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesPhishingStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/AbusedLegitBotNetCommandAndControlDomainsStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesSuspectStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesExploitsActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesEmergingEventsStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareWebActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesIOCActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareCoinminingActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/MalwareDomainsStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesScannersActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/AbusedLegitMalwareDomainsStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareMobileStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/BotNetCommandAndControlDomainsActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetWebStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetWindowsStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesDoSActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesDoSStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesWebAttacksActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareMobileActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/MalwareDomainsActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetWebActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesBotnetWindowsActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesIOCStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesWebAttacksStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareCoinminingStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesFUPStrictOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesFUPActionOrder",
      # "arn:aws:network-firewall:${var.aws_region}:aws-managed:stateful-rulegroup/ThreatSignaturesMalwareWebStrictOrder",
  ])
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
      for_each = local.managed_rule_group_arns
      content {
        resource_arn = stateful_rule_group_reference.value
      }
    }
  }
}