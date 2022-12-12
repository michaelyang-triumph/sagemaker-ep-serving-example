terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "4.36.1"
        }
    }
}

provider "aws" {
  region = "${var.aws_region}"
}

# create lambda function to serve model endpoint
module "model_serving_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  create_role = false

  function_name = local.lambda_function_name
  lambda_role   = aws_iam_role.model_serving_lambda_role.arn
  handler       = "model_serving.lambda_handler"
  runtime       = "python3.9"
  timeout       = 60
  publish       = true

  source_path = [{
    path             = "${path.module}/lambda"
    # pip_requirements = true
  }]
  environment_variables = {
    ENDPOINT_NAME = var.model_endpoint_name
    MODEL_NAME    = var.model_name
    LOG_LEVEL     = var.log_level
  }

  tags = local.tags
}
