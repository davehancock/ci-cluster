variable "region" {
  default = "eu-west-1"
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

variable "ssh_key_name" {
  default = "dave-aws"
}

variable "node_size" {
  default = "t2.nano"
}

variable "hosted_zone_id" {
  default = "Z2K7Z8BOTLHT2O"
}

variable "domain_name" {
  default = "djh.host"
}

variable "dns_records" {
  type = "list"
  default = [
    "jenkins"
  ]
}
