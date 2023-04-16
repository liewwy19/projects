module "s3bucket" {
  source = "./terraform-aws-s3"
}

module "ddbTable" {
  source = "./terraform-aws-ddb"
}
