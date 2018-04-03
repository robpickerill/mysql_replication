output "public_ip" {
  description = "List of up public IPs for AWS Instances"
  value = "${aws_instance.mysql-instance.*.public_ip}"
}

