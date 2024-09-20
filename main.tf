resource "aws_key_pair" "ssh_keypair" {
  key_name   = "${var.project_name}-${var.project_environment}"
  public_key = file("mykey.pub")
  tags = {
    Name = "${var.project_name}-${var.project_environment}"
  }
}

resource "aws_security_group" "webserver_frontent" {
  name        = "${var.project_name}-${var.project_environment}-frontent"
  description = "${var.project_name}-${var.project_environment}-frontent"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.project_environment}-frontent"
  }
}
resource "aws_vpc_security_group_ingress_rule" "frontend_rules" {

  for_each = toset(var.frontend_ports)

  security_group_id = aws_security_group.webserver_frontent.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = each.key
  to_port           = each.key
}
resource "aws_vpc_security_group_egress_rule" "outbound_ipv4_rule" {

  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  from_port         = "-1"
  to_port           = "-1"
  security_group_id = aws_security_group.webserver_frontent.id
}
resource "aws_vpc_security_group_egress_rule" "outbound_ipv6_rule" {

  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
  from_port         = "-1"
  to_port           = "-1"
  security_group_id = aws_security_group.webserver_frontent.id
}

resource "aws_instance" "frontend" {

  ami                         = var.ami_id
  instance_type               = var.ec2_type
  key_name                    = aws_key_pair.ssh_keypair.key_name
  vpc_security_group_ids      = [aws_security_group.webserver_frontent.id]
  monitoring                  = false
  user_data_replace_on_change = true
  user_data                   = file("setup.sh")
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${var.project_name}-${var.project_environment}-frontend"
  }
}
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [aws_instance.frontend.public_ip]
}
