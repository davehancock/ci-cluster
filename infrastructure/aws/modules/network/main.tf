resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "internet_access" {
  route_table_id = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_block}"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "ec2_default" {

  name = "${var.app_prefix}-ec2-security-group"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

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

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_eip" "eip" {
  instance = "${var.instance_id}"
  vpc = true
}

resource "aws_route53_record" "domain_routing_alias" {
  zone_id = "${var.hosted_zone_id}"
  name = "${var.domain_name}"
  type = "A"
  ttl = 5

  records = [
    "${aws_eip.eip.public_ip}"
  ]
}

resource "aws_route53_record" "cname_records" {
  zone_id = "${var.hosted_zone_id}"
  name = "www"
  type = "CNAME"
  ttl = 5
  records = [
    "${var.domain_name}"
  ]
}
