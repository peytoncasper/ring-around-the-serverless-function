  
resource "aws_security_group" "consul" {
  name_prefix = "consul"

  ingress {
    from_port   = 22
    to_port     = 22
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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ami-ubuntu-18.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["290148839206"] # Canonical
}

resource "aws_instance" "consul" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "a1.large"

  vpc_security_group_ids = [aws_security_group.consul.id]
}