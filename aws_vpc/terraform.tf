
#Author: Alexandru Raul
terraform {
  required_version = "~> 1.5.2"  # Specify the minimum required Terraform version here
}


terraform {
  backend "s3" {
    bucket = "cloudifferent-dev-terraform-s3-tfstate-bucket"
    key    = "dev/cloudifferent-dev-terraform-vpc-state-file"
    region = "us-west-2"
    dynamodb_table = "cloudifferent_dev_terraform_dynamodb_tfstate_table"
    encrypt = "true"
}

}