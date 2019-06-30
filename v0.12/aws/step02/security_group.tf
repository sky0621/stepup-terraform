# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "web-server-security-group" {
  name = "web-server-security-group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
