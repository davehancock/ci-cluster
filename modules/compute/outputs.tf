output "instance_ids" {
  value = [
    "${aws_instance.bootstrap_node.id}"
  ]
}
