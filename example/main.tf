module "nw" {
  source                = "../"
  external_vpc_ip_cidr  = ["10.0.0.0/16"]
  share_tgw_account_ids = ["1234567890"]
}