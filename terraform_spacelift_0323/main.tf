# this vm created manually for DevOps Bootcamp 2023 (Cognixia)
# imported into local terraform state (@Desktop)
resource "aws_instance" "devOps_bootcamp" {
  ami           = "ami-05c8486d62efc5d07"
  instance_type = "t2.micro"

  tags = {
    "Name"      = "git-vm"
    "Resources" = "DevOps Bootcamp 2023"
  }
}
