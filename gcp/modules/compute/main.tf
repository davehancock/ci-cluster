data "template_file" "bootstrap_cloud_config" {
  template = "${file("${path.module}/../../../cloud-config/cloud-config.tpl")}"

  vars {
    ci_webhook_token = "${var.ci_webhook_token}"
  }
}

// Create a new instance
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
  }

  metadata {
    user-data = "${data.template_file.bootstrap_cloud_config.rendered}"
  }

}
