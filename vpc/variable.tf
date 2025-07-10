variable "environment" {
  type    = string
  default = "stage"
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "remote_state_bucket" {
  type = string
}

variable "remote_state_region" {
  type = string
}