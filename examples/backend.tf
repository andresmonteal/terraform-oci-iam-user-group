terraform {
  backend "s3" {
    key = "path/to/state/terraform.tfstate"
  }
}