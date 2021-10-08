terraform {
  backend "s3" {
    bucket = "terraform-statebucket-ybhackathon2021"
    key    = "account/state.tf"
    region = "eu-central-1"
  }
}
