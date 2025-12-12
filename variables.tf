variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name_tag" {
  type    = string
  default = "my-vpc-valeria"    # <- CAMBIA por el tag:Name de TU VPC
}

variable "create_keypair" {
  type    = bool
  default = false
}

variable "keypair_public_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "subnet_id_override" {
  type    = string
  default = ""    # deja vacío para usar data source; o pon "subnet-0abc1234" para forzar
}
