terraform {
  backend "s3" {
    bucket = "ogoma-wp-terraform-state"
    key = "production/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}