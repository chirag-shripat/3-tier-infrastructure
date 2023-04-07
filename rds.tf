resource "aws_security_group" "rds_sg" {
  
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier             = "rdsinstance"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.28"
  instance_class         = "db.t2.micro"
  name                   = "champalal"
  username               = "admin"
  password               = "xnux9617?"
  parameter_group_name   = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "rds_server"
  }
}


resource "aws_db_subnet_group" "DB_subnet" {
  name       = "privat-subnet"
  subnet_ids = [aws_subnet.private-subnet.id, aws_subnet.public-subnet.id]

  tags = {
    Name = "DB_subnet"
  }
}