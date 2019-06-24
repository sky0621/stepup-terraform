# https://www.terraform.io/docs/configuration/providers.html
provider "aws" {
  region = "ap-northeast-1"
}

# https://www.terraform.io/docs/providers/aws/r/vpc.html
resource "aws_vpc" "ex-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true # DNSサーバによる名前解決の有効化
  enable_dns_hostnames = true # VPC内リソースにパブリックDNSホスト名を自動割当
}

# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "ex-pub" {
  vpc_id                  = aws_vpc.ex-vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true # Subnet内リソースにパブリックIPを自動割当
  availability_zone       = "ap-northeast-1a"
}

# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
resource "aws_internet_gateway" "ex-ig" {
  vpc_id = aws_vpc.ex-vpc.id
}

# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "ex-pub-rt" {
  vpc_id = aws_vpc.ex-vpc.id
}

# https://www.terraform.io/docs/providers/aws/r/route.html
resource "aws_route" "ex-pub-r" {
  route_table_id         = aws_route_table.ex-pub-rt.id
  gateway_id             = aws_internet_gateway.ex-ig.id
  destination_cidr_block = "0.0.0.0/0"
}

# https://www.terraform.io/docs/providers/aws/r/instance.html
resource "aws_instance" "web-server" {
  ami                    = "ami-0f9ae750e8274075b" # 
  instance_type          = "t2.micro"              # https://aws.amazon.com/jp/ec2/instance-types/
  vpc_security_group_ids = [aws_security_group.web-server-security-group.id]

  user_data = <<EOF
    #!/bin/bash
    sudo yum -y install git
    git clone https://github.com/sky0621/go-experiment.git
    cd go-experiment
    ./go-experiment
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
