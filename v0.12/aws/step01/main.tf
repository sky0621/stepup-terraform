# https://www.terraform.io/docs/configuration/providers.html
provider "aws" {
  region = "ap-northeast-1"
}

# https://www.terraform.io/docs/providers/aws/r/instance.html
resource "aws_instance" "web-server" {
  ami                    = "ami-0f9ae750e8274075b" # 
  instance_type          = "t2.micro"              # https://aws.amazon.com/jp/ec2/instance-types/
  vpc_security_group_ids = [aws_security_group.web-server-security-group.id]

  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
EOF
}

# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "web-server-security-group" {
  name = "web-server-security-group"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web-server-public-dns" {
  value = aws_instance.web-server.public_dns
}
