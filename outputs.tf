output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "ec2_public_ip" {
  value       = aws_instance.web.public_ip
  description = "IP pública de la instancia EC2"
}
