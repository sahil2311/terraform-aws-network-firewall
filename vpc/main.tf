module "nw" {
  source                = "../"
  external_vpc_ip_cidr  = ["20.20.0.0/16"]
  share_tgw_account_ids = ["752711392763"]
  aws_region            = var.aws_region
  environment           = var.environment
}