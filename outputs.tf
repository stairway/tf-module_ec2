output "ec2_public_ip" {
  value = aws_instance.myec2.public_ip
}

output "sg_ssh" {
  value = aws_security_group.allow_ssh
}

output "sg_http" {
  value = aws_security_group.allow_http_inbound
}