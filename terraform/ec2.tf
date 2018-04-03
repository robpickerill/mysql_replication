data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "MySQL-LAB" {
  key_name   = "mysql-lab"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+6hUM/qwRm+2MBL7Vi1AM2CGTM1OBSUESJrI5wtY3eroElA/t/CLnfDatfu5y9GwvvzUFGtLOwvPsqM02ES5cv7OimmocU11cVlP7drsVKVWC9Y2tl+E5c+Yl/oTaihQ7GF97PEhyWLevbG+hGMTi8wKjGVHmTTuf6mGDHq0xFggEwvXoE9wtR4RYpVIDt/qEzdIYnyvy2u208Mlj3w7D6Ho+S62EvDhVR4TUF9wpcQ7ypy58NkwNWgyQXRieZyrToPwzOXDU+XiIwjem2HRRH96csMwgZoUr3G5r92it1oFfw15FU3ERUvgrzFSyRKaAY3yBX3kQzJk7GQszzWKYUQA+dV9Z8cgQ93TdRT+GqTmOTrhVXFzYODAUgn8DXjiJpU841wRUzmA47R3S8Mn8eM3hDF9A4wCniI7smsp+O6JZoCbOY211ZT/fdBF4seLjphqQLOizbOwQL+0AjykLIDRjj0P0GQz73ZyZYcK87FjEM66g/Zvbiy5B5HLxGEg7z4FZ26ZukfsRX/oIavmiaS8n4s88MNbOado4/8TqOzHpWfdSuQNl5UzpkwjUYUNY2rvBvEXzxQpwhOqioplVNuohC8Cg4ZMLOzvm20fSPNFHBfX+VpZoPQjEmvJf8uYxylimOAtxB498JOO7CtaaszEwqfd0hP5XM5Um33Sv1Q== MySQL-LAB"
}

resource "aws_instance" "mysql-instance" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.mysql-securitygroup.id}"]
  subnet_id = "${aws_subnet.public_subnet_a.id}"
  count = "${var.instance_count}"
  key_name = "mysql-lab"

  tags {
    Name = "MySQL-LAB"
    Env = "LAB"
  }
}

resource "aws_security_group" "mysql-securitygroup" {
  name = "mysql-inbound"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "MySQL-LAB"
  }

}

