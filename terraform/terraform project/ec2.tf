

resource "aws_instance" "import" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = var.instance_type

  user_data_replace_on_change = false

  tags = {
    Name = "terraform import"
  }
}