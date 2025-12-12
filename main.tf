#############################################
# 1. CREAR VPC
#############################################
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "mi-vpc"
  }
}

#############################################
# 2. CREAR SUBNET PÚBLICA
#############################################
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "mi-public-subnet"
  }
}

#############################################
# 3. INTERNET GATEWAY
#############################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "mi-igw"
  }
}

#############################################
# 4. ROUTE TABLE PUBLICA
#############################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "mi-public-rt"
  }
}

#############################################
# 5. ASOCIAR SUBNET CON ROUTE TABLE
#############################################
resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#############################################
# 6. SECURITY GROUP
#############################################
resource "aws_security_group" "web_sg" {
  name   = "mi-web-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mi-web-sg"
  }
}

#############################################
# 7. EC2
#############################################
resource "aws_instance" "web" {
  ami                         = "ami-051b98ceceb268091"
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  user_data = <<EOF
#!/bin/bash
sudo yum install httpd -y
echo "Hola desde VPC creada con Terraform!" > /var/www/html/index.html
sudo systemctl enable --now httpd
EOF

  tags = {
    Name = "mi-ec2"
  }
}
