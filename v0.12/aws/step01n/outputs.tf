
output "web-server-public-dns" {
  value = "${aws_instance.web-server.public_dns}"
}
