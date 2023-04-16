terraform {
  backend "s3" {
    bucket         = "terraform-state-information-0416"
    region         = "ap-southeast-1"
    key            = "state/terraform.tfstate"
    dynamodb_table = "ddb-state-information"
    profile        = "vscode"
  }
}
