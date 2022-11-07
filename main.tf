resource "aws_instance" "myec2" {
  ami                    = local.ec2_ami
  instance_type          = lookup(var.instance_type,terraform.workspace)
  key_name               = "terraform-key"
  security_groups        = [aws_security_group.allow_ssh.name, aws_security_group.allow_http_inbound.name]
  # vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http_inbound.id]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./terraform-key.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1",
      "sudo systemctl start nginx",
      "sudo yum install -y nano"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum remove -y nano"
    ]
  }

  tags = {
    "Name" = "ec2_nginx"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH into VPC"
    from_port   = local.ssh_port
    to_port     = local.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound allowed"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "allow_ssh"
  }
}

resource "aws_security_group" "allow_http_inbound" {
  name        = "allow_http_inbound"
  description = "Allow HTTP inbound traffic"

  ingress {
    description = "HTTP into VPC"
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "allow_http_inbound"
  }
}

locals {
  ec2_ami = "ami-09d3b3274b6c5d4aa"
  http_port = 80
  ssh_port = 22
}