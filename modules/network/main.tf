// Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

// Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

// Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.default.id}"
}

// Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "${var.region}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

// A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elb" {

  name = "elb-security-group"
  vpc_id = "${aws_vpc.default.id}"
  description = "ELB specific group"

  // HTTP access from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  // outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}


// Our default security group to access the instances over SSH and HTTP
resource "aws_security_group" "ec2_default" {

  name = "ec2-security-group"
  vpc_id = "${aws_vpc.default.id}"
  description = "Default group for any EC2 instance"

  // SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  // HTTP access from the VPC
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "10.0.0.0/16"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "10.0.0.0/16"]
  }

  // outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}


// Create Elastic Load Balancer for external access to the VPC
resource "aws_elb" "elb_main" {

  name = "elb-main"

  subnets = [
    "${aws_subnet.default.id}"]
  security_groups = [
    "${aws_security_group.elb.id}"]
  instances = [
    "${var.instance_ids}"]

  listener {
    instance_port = 80
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }

  health_check {
    target = "TCP:80"
    healthy_threshold = 2
    unhealthy_threshold = 8
    interval = 15
    timeout = 5
  }

}


// DNS Records (Route 53 integration)
resource "aws_route53_record" "cname_records" {
  count = "${length(var.dns_records)}"
  zone_id = "${var.hosted_zone_id}"
  name = "${element(var.dns_records, count.index )}"
  type = "CNAME"
  ttl = 5
  records = [
    "${var.domain_name}"
  ]
}

resource "aws_route53_record" "domain_routing_alias" {
  zone_id = "${var.hosted_zone_id}"
  name = "${var.domain_name}"
  type = "A"

  alias {
    name = "${aws_elb.elb_main.dns_name}"
    zone_id = "${aws_elb.elb_main.zone_id}"
    evaluate_target_health = true
  }
}
