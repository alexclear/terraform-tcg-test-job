terraform {
  backend "s3" {
    bucket = "terraform-ac-tfstate"
    key    = "tfstate"
    region = "us-east-1"
  }
}
