module "nw" {
  source                          = "../"
  external_vpc_ip_cidr            = ["20.20.0.0/16"]
  share_tgw_account_ids           = ["1234567890"]
  attached_stateful_managed_rules = true
  aws_region                      = var.aws_region
  environment                     = var.environment
}