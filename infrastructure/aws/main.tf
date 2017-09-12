provider "aws" {
  region = "${var.region}"
}

module "compute" {
  source = "./modules/compute"
  project_name = "${var.project_name}"
  domain_name = "${var.domain_name}"
  email_address = "${var.email_address}"
  region = "${var.region}"
  amis = "${var.amis}"
  node_size = "${var.node_size}"
  ssh_key_name = "${var.ssh_key_name}"
  security_group_ids = "${module.network.security_group_ids}"
  subnet_id = "${module.network.subnet_id}"
  ci_webhook_token = "${var.ci_webhook_token}"
  freighter_provider = "${var.freighter_provider}"
  freighter_token = "${var.freighter_token}"
}

module "network" {
  source = "./modules/network"
  project_name = "${var.project_name}"
  region = "${var.region}"
  hosted_zone_id = "${var.hosted_zone_id}"
  cidr_block = "${var.cidr_block}"
  domain_name = "${var.domain_name}"
  instance_id = "${module.compute.instance_id}"
}
