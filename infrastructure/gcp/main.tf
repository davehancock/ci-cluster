provider "google" {
  project = "ci-cluster"
  region = "${var.region}"
}

module "compute" {
  source = "./modules/compute"
  project_name = "${var.project_name}"
  zone = "${var.zone}"
  node_size = "${var.node_size}"
  image = "${var.image}"
  ci_webhook_token = "${var.ci_webhook_token}"
  freighter_provider = "${var.freighter_provider}"
  freighter_token = "${var.freighter_token}"
}

module "network" {
  source = "./modules/network"
  project_name = "${var.project_name}"
  hosted_zone_id = "${var.hosted_zone_id}"
  domain_name = "${var.domain_name}"
  instance_id = "${module.compute.instance_id}"
}
