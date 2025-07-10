module "nw" {
  source                               = "../"
  external_vpc_ip_cidr                 = ["172.31.0.0/16"]
  share_tgw_account_ids                = ["752711392763"]
  attached_stateful_managed_rules      = true
  attached_stateless_icmp_blocked_rule = true
  aws_region                           = var.aws_region
  environment                          = var.environment
}