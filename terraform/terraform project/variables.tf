variable "instance_type" {
    type    = string
    default = "t3.micro"


  
}

locals {

    instance_ami = "ami-0b6d9d3d33ba97d99"
    

}

output "instance_id" {
    description = "The ID of the the EC2 instance"
    value = aws_instance.import.id
  
}