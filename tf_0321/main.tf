resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.8.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "dev_subnet1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.8.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "dev_rt_public" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    "Name" = "dev_rt_public"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.dev_rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_igw.id
}

resource "aws_route_table_association" "dev_rta_public" {
  subnet_id      = aws_subnet.dev_subnet1.id
  route_table_id = aws_route_table.dev_rt_public.id
}

resource "aws_security_group" "dev_sg_public" {
  name        = "public_sg"
  description = "public security group"
  vpc_id      = aws_vpc.dev_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", "61.6.119.161/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "dev_auth" {
  key_name   = "awsDevKey"
  public_key = file("~/.ssh/awsDevKey.pub")
}

resource "aws_instance" "dev_node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.dev_auth.key_name
  vpc_security_group_ids = [aws_security_group.dev_sg_public.id]
  subnet_id              = aws_subnet.dev_subnet1.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 20
  }

  tags = {
    "Name" = "dev-node"
  }
}
