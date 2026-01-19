data "terraform_remote_state" "dns" {
  backend = "s3"
  config = {
    bucket = "ogoma-wp-terraform-state"
    key    = "dns/terraform.tfstate"
    region = "us-east-1"
  }
}
