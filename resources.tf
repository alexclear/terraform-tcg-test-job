resource "aws_key_pair" "tftestmaster" {
  key_name   = "tftestmaster-key"
  public_key = var.ssh_key

  tags = {
    Name = "tftest"
  }
}

resource "aws_vpc" "private" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tftest"
  }
}

resource "aws_security_group" "public" {
  name        = "tftest_public"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.private.id

  ingress {
    description = "SSH from public IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.public_ips
  }

  ingress {
    description = "8084"
    from_port   = 8084
    to_port     = 8084
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tftest"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.private.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "tftest"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.private.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.private.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "ext" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.main.id
}

data "aws_ami" "centos7" {
  most_recent = true

  filter {
    name   = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"] # CentOS official
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["aws-marketplace"]
}

resource "aws_instance" "tcg" {
  ami                         = data.aws_ami.centos7.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet_1.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.tftestmaster.id
  vpc_security_group_ids      = [aws_security_group.public.id]

  tags = {
    Name = "tcg"
  }
}

resource "aws_ebs_volume" "mysql" {
  availability_zone = aws_instance.mysql.availability_zone
  size              = 10

  tags = {
    Name = "mysql"
  }
}

output "mysql_address" {
  value = aws_instance.mysql.private_ip
}

resource "aws_instance" "mysql" {
  ami                         = data.aws_ami.centos7.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet_1.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.tftestmaster.id
  vpc_security_group_ids      = [aws_security_group.public.id]

  tags = {
    Name = "mysql"
  }
}

resource "aws_volume_attachment" "mysql" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.mysql.id
  instance_id = aws_instance.mysql.id
}
