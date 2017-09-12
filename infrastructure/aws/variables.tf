variable "region" {
  default = "eu-west-1"
}

variable "project_name" {
  default = "ci-cluster"
}

variable "amis" {
  type = "map"
  default = {
    // EU West-1 CoreOS Alpha HVM Image
    eu-west-1 = "ami-f44f1592"
    eu-west-1a = "ami-f44f1592"
    eu-west-1b = "ami-f44f1592"
    eu-west-1c = "ami-f44f1592"
  }
}

variable "node_size" {
  default = "t2.small"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

// Override Me!....
variable "hosted_zone_id" {
  default = "Z3VFJWA6WOMV2B"
}

variable "domain_name" {
  default = "djh.services"
}

variable "email_address" {
  default = "daves125125@gmail.com"
}

variable "ci_webhook_token" {
}

variable "freighter_provider" {
}

variable "freighter_token" {
}

variable "ssh_key_name" {
  default = "dave-aws"
}
