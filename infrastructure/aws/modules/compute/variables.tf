variable "region" {
}

variable "app_prefix" {
  default = "ci-cluster"
}

variable "amis" {
  type = "map"
}

variable "ssh_key_name" {
}

variable "security_group_ids" {
  type = "list"
}

variable "subnet_id" {
}

variable "node_size" {
}

variable "ci_webhook_token" {
}

variable "freighter_provider" {
}

variable "freighter_token" {
}
