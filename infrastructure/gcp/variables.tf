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
