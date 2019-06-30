# https://www.terraform.io/docs/providers/aws/r/instance.html
resource "aws_instance" "web-server" {
  ami                    = "ami-0f9ae750e8274075b" # https://aws.amazon.com/jp/amazon-linux-2/
  instance_type          = "t2.micro"              # https://aws.amazon.com/jp/ec2/instance-types/
  vpc_security_group_ids = ["${aws_security_group.web-server-security-group.id}"]

  user_data = file("./web-server-setup.sh")
}
