terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "4.36.1"
        }
    }
}

# locals {
#   aws_iad = "us-east-1"
#   aws_cmh = "us-east-2"
#   aws_sfo = "us-west-1"
#   aws_pdx = "us-west-2"

#   stage = "dev"
# }

module "model_api" {
  source              = "../modules/model_api"
  aws_region          = "${var.aws_region}"
  stage               = "${var.stage}"
  log_level           = "${var.log_level}"
  model_name          = "${var.model_name}"
  model_endpoint_name = "${var.model_endpoint_name}"
}