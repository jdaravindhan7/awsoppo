terraform {
  backend "s3" {
    bucket = "redbullracingmaxverstappen"
    key    = "delltech/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
