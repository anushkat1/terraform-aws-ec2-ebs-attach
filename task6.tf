provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_key_pair" "kp1" {
  key_name   = "key1"
  public_key = var.pubkey
}

resource "aws_security_group" "my_firewall" {

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }

  tags = {
    Name = "sgf"
  }
}

resource "aws_instance" "task6" {
  ami           = var.ami
  instance_type = var.mtype
  key_name = aws_key_pair.kp1.key_name
  security_groups= ["${aws_security_group.my_firewall.name}"]
  tags= {
    Name = "Task 6 instance"
  }
}

resource "aws_ebs_volume" "st1" {
 availability_zone = aws_instance.task6.availability_zone
 size = 1
 tags= {
    Name = "My volume"
  }
}

resource "aws_volume_attachment" "ebs" {
 device_name = "/dev/sdh"
 volume_id = aws_ebs_volume.st1.id
 instance_id = aws_instance.task6.id 
}

