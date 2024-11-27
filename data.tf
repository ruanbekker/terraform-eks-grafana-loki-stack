data "aws_subnet" "eu-west-1a-subnet" {
  availability_zone = "eu-west-1a"
  tags = {
    "Name" = "subnet-eu-west-1a"
  }
}

