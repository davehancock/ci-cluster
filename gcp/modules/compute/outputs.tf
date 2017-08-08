output "instance_id" {
  value = "${google_compute_instance.bootstrap_node.self_link}"
}
