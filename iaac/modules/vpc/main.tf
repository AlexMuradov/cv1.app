resource "aws_vpc" "cv1app" {
  cidr_block = "10.0.0.0/16"      

  tags = {
    Name = "cv1app-vpc"
  }
}

resource "aws_internet_gateway" "cv1" {
  vpc_id = aws_vpc.cv1app.id

  tags = {
    Name = "igw-cv1app"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.cv1app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cv1.id
  }

  tags = {
    Name = "public-subnet-route"
  }
}

variable "subnets" {
  type = list
  default = [
      { 
        cidr = "1",
        az = "eu-central-1a"
      },
      {
        cidr = "2",
        az = "eu-central-1b"
      },
      {
        cidr = "3",
        az = "eu-central-1c"
      }
    ]
}

resource "aws_subnet" "cv1app" {
  count = length(var.subnets)
  vpc_id     = aws_vpc.cv1app.id
  cidr_block = "10.0.${count.index + 1}.0/24"
  availability_zone = var.subnets[count.index]["az"]

  tags = {
    Name = "cv1app-subnet ${var.subnets[count.index]["az"]}"
  }
}

resource "aws_security_group" "cv1app" {
  vpc_id      = aws_vpc.cv1app.id
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}