variable "aws_region" {
    type = string
    description = "my aws region"
    default = "ap-south-1"
}

variable "aws_access_key" {
    type = string
    description = "my aws access key"
    default = "aoiiaksfgusfpdcb "
}

variable "aws_secret_key" {
    type = string
    description = "my aws secret key"
    default = "jaa9awepdefbkw"
}

variable "project_name" {
    type = string
    description = "my project name"
    default = "zomato"
}

variable "project_environment" {
    type = string
    description = "my project environment"
    default = "prod"
}
variable "project_owner" {
    type = string
    description = "project owner name"
    default = "Anitta"
}

variable "vpc_id" {

    type = string
    description = "default id of vpc"
    default = "vpc-018b4921e618cc4e7"
}

variable "ami_id" {

    type = string
    description = "my ami id"
    default = "ami-0e53db6fd757e38c7"
}

variable "ec2_type" {

    type = string
    description = "my ec2 type"
    default = "t2.micro"
}
provider "aws" {
    region = var.aws_region
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key

}
#create key-pair
resource "aws_key_pair" "ssh_keypair" {
  key_name   = "${var.project_name}-${var.project_environment}"
  public_key = file("mykey.pub")
  tags = {
        Name = "${var.project_name}-${var.project_environment}"
        Project = var.project_name
        Environment = var.project_environment
        Owner = var.project_owner
    }
}
#create frontent sg

resource "aws_security_group" "webserver_frontent" {
  name        = "${var.project_name}-${var.project_environment}-frontent"
  description = "${var.project_name}-${var.project_environment}-frontent"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.project_environment}-frontent"
    Project = var.project_name
    Environment = var.project_environment
    Owner = var.project_owner
  }
}

resource "aws_security_group_rule" "frontend_http_rule" {

    type       = "ingress"
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks= ["0.0.0.0/0"]
    security_group_id = aws_security_group.webserver_frontent.id
}

resource "aws_security_group_rule" "frontend_https_rule" {

    type       = "ingress"
    from_port  = 443
    to_port    = 443
    protocol   = "tcp"
    cidr_blocks= ["0.0.0.0/0"]
    security_group_id = aws_security_group.webserver_frontent.id
}

resource "aws_security_group_rule" "frontend_egress" {

    type       = "egress"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks= ["0.0.0.0/0"]
    security_group_id = aws_security_group.webserver_frontent.id
}

resource "aws_security_group" "remote_ssh" {
  name        = "${var.project_name}-${var.project_environment}-ssh"
  description = "${var.project_name}-${var.project_environment}-ssh"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.project_environment}-ssh"
    Project = var.project_name
    Environment = var.project_environment
    Owner = var.project_owner
  }
}

resource "aws_security_group_rule" "frontend_ssh" {

    type       = "ingress"
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
    cidr_blocks= ["0.0.0.0/0"]
    security_group_id = aws_security_group.remote_ssh.id
}

resource "aws_security_group_rule" "remote_egress" {

    type       = "egress"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks= ["0.0.0.0/0"]
    security_group_id = aws_security_group.remote_ssh.id
}

resource "aws_instance" "frontend" {

    ami = var.ami_id
    instance_type = var.ec2_type
    key_name = aws_key_pair.ssh_keypair.key_name
    vpc_security_group_ids = [aws_security_group.webserver_frontent.id , aws_security_group.remote_ssh.id]
    monitoring = false
    tags = {
        Name = "${var.project_name}-${var.project_environment}-frontend"
        Project = var.project_name
        Environment = var.project_environment
        Owner = var.project_owner
    }
}
