terraform {
  backend "s3" {
    bucket       = "gic-terraform-state-bucket"
    key          = "gic/terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
}