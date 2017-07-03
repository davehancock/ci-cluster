data "template_file" "bootstrap_cloud_config" {
  template = "${file("${path.module}/../../cloud-config/cloud-config.tpl")}"
}

resource "aws_instance" "bootstrap_node" {
  key_name = "${var.ssh_key_name}"
  ami = "${lookup(var.amis, var.region)}"
  availability_zone = "${var.region}"
  instance_type = "${var.node_size}"
  user_data = "${data.template_file.bootstrap_cloud_config.rendered}"
  vpc_security_group_ids = [
    "${var.security_group_ids}"
  ]

  // TODO In a production environment it's more common to have a separate private subnet for backend instances.
  subnet_id = "${var.subnet_id}"
}
