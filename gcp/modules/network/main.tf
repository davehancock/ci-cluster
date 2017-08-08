resource "google_compute_address" "www" {
  name = "www-address"
}

resource "google_compute_target_pool" "www" {
  name = "www-target-pool"
  instances = ["${var.instance_id}"]
  health_checks = ["${google_compute_http_health_check.http.name}"]
}

resource "google_compute_forwarding_rule" "http" {
  name = "www-http-forwarding-rule"
  target = "${google_compute_target_pool.www.self_link}"
  ip_address = "${google_compute_address.www.address}"
  port_range = "80"
}

resource "google_compute_forwarding_rule" "https" {
  name = "www-https-forwarding-rule"
  target = "${google_compute_target_pool.www.self_link}"
  ip_address = "${google_compute_address.www.address}"
  port_range = "443"
}

resource "google_compute_http_health_check" "http" {
  name = "www-http-basic-check"
  request_path = "/"
  check_interval_sec = 1
  healthy_threshold = 1
  unhealthy_threshold = 10
  timeout_sec = 1
}

resource "google_compute_firewall" "www" {
  name = "www-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}


# TODO Leaving route53 in here as domain in managed here...
resource "aws_route53_record" "domain_routing_alias" {
  zone_id = "${var.hosted_zone_id}"
  name = "${var.domain_name}"
  type = "A"
  ttl = 5

  records = [
    "${google_compute_address.www.address}"
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
