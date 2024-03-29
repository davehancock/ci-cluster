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

resource "aws_instance" "bootstrap_node" {
  key_name = "${var.ssh_key_name}"
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "${var.node_size}"
  user_data = "${data.template_file.bootstrap_cloud_config.rendered}"
  vpc_security_group_ids = [
    "${var.security_group_ids}"
  ]
  subnet_id = "${var.subnet_id}"
  tags = {
    Name = "${format("%s-node-%d", var.project_name, 0)}"
  }
}
