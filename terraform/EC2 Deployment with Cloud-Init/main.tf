module "ec2" {
  source            = "./modules/ec2"
  subnet_id         = aws_subnet.public_subnet.id
  security_group_id = aws_security_group.sg_rules.id
}