variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "project_name" {
  default = "ci-cluster"
}

variable "image" {
  default = "coreos-cloud/coreos-stable"
}

variable "node_size" {
  default = "g1-small"
}

// Override Me!....
variable "hosted_zone_id" {
  default = "Z2K7Z8BOTLHT2O"
}

variable "domain_name" {
  default = "djh.host"
}

variable "ci_webhook_token" {
}

variable "freighter_provider" {
}

variable "freighter_token" {
}
