locals {
  org    = "tbp"
  prefix = "ml"
  stage_to_environment = {
    "dev"  = "development"
    "prod" = "production"
  }
  tags = {
    "application" = "ml-ops"
    "region"      = "${var.aws_region}"
    "environment" = "${local.stage_to_environment[var.stage]}"
  }

    lambda_function_name   = "${local.org}-${var.model_name}-serving-lambda-${var.stage}"
    lambda_iam_role_name   = "${local.org}-${var.model_name}-serving-lambda-role-${var.stage}"
    lambda_iam_policy_name = "${local.org}-${var.model_name}-serving-lambda-policy-${var.stage}"
    api_gateway_name       = "${local.org}-${var.model_name}-api-gateway-${var.stage}"
    api_gateway_stage_name = "${local.org}-${var.model_name}-api-gateway-stage-${var.stage}"
}