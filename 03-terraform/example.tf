provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_instance" "example" {
  ami                    = "ami-049a20d5e26758e27"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-055b3fccf8b0463b4"]
  key_name               = "AWS-standard"

  tags = {
    Name = "centos-lamp-example"
  }
}
