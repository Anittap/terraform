variable "aws_region" {
  type        = string
  description = "my aws region"
  default     = "ap-south-1"
}

variable "aws_access_key" {
  type        = string
  description = "my aws access key"
  default     = "soiasfbjsdpicjp"
}

variable "aws_secret_key" {
  type        = string
  description = "my aws secret key"
  default     = "aaoihewiupjkdlxvciu"
}

variable "project_name" {
  type        = string
  description = "my project name"
  default     = "swiggy"
}
variable "ami_id" {

  type        = string
  description = "my ami id"
  default     = "ami-0e53db6fd757e38c7"
}

variable "ec2_type" {

  type        = string
  description = "my ec2 type"
  default     = "t2.micro"
}
variable "project_environment" {
  type        = string
  description = "my project environment"
  default     = "prod"
}
variable "project_owner" {
  type        = string
  description = "project owner name"
  default     = "Anitta"
}

variable "vpc_id" {

  type        = string
  description = "default id of vpc"
  default     = "vpc-018b4921e618cc4e7"
}
variable "frontend_ports" {

  type        = list(string)
  description = "frontend security group ports"
  default     = ["80", "443", "22"]
}
variable "domain_name" {

  type        = string
  description = "domain name"
  default     = "anitta.cloud"
}
