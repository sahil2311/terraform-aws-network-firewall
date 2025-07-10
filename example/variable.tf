variable "environment" {
  type    = string
  default = "stage"
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

#######################################################################################################################
#################################### DEV ##############################################################################
#######################################################################################################################

variable "aws_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "aws_cidrs_public" {
  type    = list(string)
  default = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
}

variable "aws_cidrs_inspection" {
  type    = list(string)
  default = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
}

variable "aws_cidrs_tgw" {
  type    = list(string)
  default = ["10.0.96.0/20", "10.0.112.0/20", "10.0.128.0/20"]
}