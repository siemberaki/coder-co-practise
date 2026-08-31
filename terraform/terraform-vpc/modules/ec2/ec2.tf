resource "aws_instance" "ec2" {
  ami           = "ami-0fe74bfcad4fd6bd2"
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    var.security_group_id
  ]

  associate_public_ip_address = true

  user_data = file("${path.module}/cloud-init.yaml")

  tags = {
    Name = local.instance_tag
  }
}