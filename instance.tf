## making instance in this vpc
resource "aws_instance" "server" {
    ami = "ami-064eb0bee0c5402c5"
    instance_type = var.instance_type
    key_name = "singapore_keys"
    availability_zone = "ap-southeast-1a"
    subnet_id = aws_subnet.public-subnet.id
    vpc_security_group_ids = [aws_security_group.project-sg.id]

    tags = { 
        "Name" = "server"
    }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("singapore_keys.pem")
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
        "sudo yum install -y httpd",
        "sudo systemctl start httpd",
        "sudo systemctl enable httpd",
        "sudo yum install mysql -y"
        
    ]
  }

  provisioner "file" {
    source = "./index.html"
    destination = "/home/ec2-user/index.html"
  }
  /*provisioner "file" {
    source = "./css"
    destination = "/var/www/html/"
  }
  provisioner "file" {
    source = "./img"
    destination = "/var/www/html/"
  }
  provisioner "file" {
    source = "./smartcity"
    destination = "/var/www/html/"
  }*/
}