data "template_file" "bootstrap_cloud_config" {
  template = "${file("${path.module}/../../../cloud-config/cloud-config.tpl")}"

  vars {
    domain_name = "${var.domain_name}"
    project_name = "${var.project_name}"
    email_address = "${var.email_address}"
    ci_webhook_token = "${var.ci_webhook_token}"
    freighter_provider = "${var.freighter_provider}"
    freighter_token = "${var.freighter_token}"
  }
}

resource "google_compute_instance" "bootstrap_node" {
  name = "${format("%s-node-%d", var.project_name, 0)}"
  zone = "${var.zone}"
  machine_type = "${var.node_size}"

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    user-data = "${data.template_file.bootstrap_cloud_config.rendered}"
  }

}
