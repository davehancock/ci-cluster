provider "aws" {
  region = "${var.region}"
}

module "compute" {
  source = "./modules/compute"
  region = "${var.region}"
  amis = "${var.amis}"
  node_size = "${var.node_size}"
  ssh_key_name = "${var.ssh_key_name}"
  security_group_ids = "${module.network.security_group_ids}"
  subnet_id = "${module.network.subnet_id}"
}

module "network" {
  source = "./modules/network"
  region = "${var.region}"
  hosted_zone_id = "${var.hosted_zone_id}"
  dns_records = "${var.dns_records}"
  domain_name = "${var.domain_name}"
  instance_ids = "${module.compute.instance_ids}"
}
