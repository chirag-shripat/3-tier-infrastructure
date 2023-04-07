provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc-for-project" {
  cidr_block = "192.168.0.0/24"
  tags = {
    "Name" = "vpc-for-project"
  }
}

## making security groups
resource "aws_security_group" "project-sg" {
    vpc_id = aws_vpc.vpc-for-project.id
    tags = {
        "Name" = "project-security-group"
    }
 
  ingress {
    description      = "inbound"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


## making both subnets

#public subnet
resource "aws_subnet" "public-subnet" {
    availability_zone = "ap-southeast-1a"
    vpc_id = aws_vpc.vpc-for-project.id
    cidr_block = "192.168.0.0/25"
    map_public_ip_on_launch = true
    
    tags = {
        "Name" = "public-subnet"
    }
}

#private subnet
resource "aws_subnet" "private-subnet" {
    availability_zone = "ap-southeast-1b"
    vpc_id = aws_vpc.vpc-for-project.id
    cidr_block = "192.168.0.128/25"
    
    tags = {
        "Name" = "private-subnet"
    }
}


## creating IGW for "vpc-for-project" vpc
resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.vpc-for-project.id

    tags = {
        "Name" = "my-igw"
    }
}

## making route tables

# public route table
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc-for-project.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }
    tags = {
        "Name" = "public_rt"
    }
}

#private route table
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.vpc-for-project.id

    tags = {
        "Name" = "private_rt"
    }
}

## associoating routing table
resource "aws_route_table_association" "route-asso-1" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "route-asso-2" {
  subnet_id = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private_rt.id
}