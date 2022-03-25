terraform {
  backend "s3" {
    bucket = "talent-academy-198769110116-tfstates-delores"
    key    = "sprint2/week1/training-terraform/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}