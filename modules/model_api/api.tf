resource "aws_apigatewayv2_api" "lambda-api" {
    name          = "${local.api_gateway_name}"
    description   = "API Gateway serving ${var.model_name} model endpoint."
    protocol_type = "HTTP"
    tags          = local.tags
}

resource "aws_apigatewayv2_stage" "lambda-stage" {
    api_id      = aws_apigatewayv2_api.lambda-api.id
    name        = "${local.api_gateway_stage_name}"
    description = "API Gateway stage serving ${var.model_name} model endpoint."
    auto_deploy = true
    tags        = local.tags
}

resource "aws_apigatewayv2_integration" "lambda-integration" {
    api_id               = aws_apigatewayv2_api.lambda-api.id
    integration_type     = "AWS_PROXY"
    connection_type      = "INTERNET"
    integration_method   = "POST"
    integration_uri      = module.model_serving_lambda.lambda_function_invoke_arn
    passthrough_behavior = "WHEN_NO_MATCH"

}

resource "aws_apigatewayv2_route" "lambda-route" {
    api_id             = aws_apigatewayv2_api.lambda-api.id
    route_key          = "GET /getPredictions"
    target             = "integrations/${aws_apigatewayv2_integration.lambda-integration.id}"
}

resource "aws_lambda_permission" "apigw" {
    statement_id  = "AllowExecutionFromAPIGateway"
    action        = "lambda:InvokeFunction"
    function_name = module.model_serving_lambda.lambda_function_name
    principal     = "apigateway.amazonaws.com"

    source_arn = "${aws_apigatewayv2_api.lambda-api.execution_arn}/*/*/*"
}

# resource "aws_api_gateway_rest_api" "model_serving_api" {
#   name        = "${local.api_gateway_name}"
#   description = "API gateway to serve ${var.model_name} model endpoint"
#   tags        = local.tags
# }

# resource "aws_api_gateway_resource" "proxy" {
#   rest_api_id = "${aws_api_gateway_rest_api.model_serving_api.id}"
#   parent_id   = "${aws_api_gateway_rest_api.model_serving_api.root_resource_id}"
#   path_part   = "{proxy+}"
# }

# resource "aws_api_gateway_method" "proxy" {
#   rest_api_id   = "${aws_api_gateway_rest_api.model_serving_api.id}"
#   resource_id   = "${aws_api_gateway_resource.proxy.id}"
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "lambda" {
#   rest_api_id = "${aws_api_gateway_rest_api.model_serving_api.id}"
#   resource_id = "${aws_api_gateway_method.proxy.resource_id}"
#   http_method = "${aws_api_gateway_method.proxy.http_method}"

#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = "${model_serving_lambda.lambda.invoke_arn}"
# }

# resource "aws_api_gateway_method" "proxy_root" {
#   rest_api_id   = "${aws_api_gateway_rest_api.model_serving_api.id}"
#   resource_id   = "${aws_api_gateway_rest_api.model_serving_api.root_resource_id}"
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "lambda_root" {
#   rest_api_id = "${aws_api_gateway_rest_api.model_serving_api.id}"
#   resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
#   http_method = "${aws_api_gateway_method.proxy_root.http_method}"

#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = "${model_serving_lambda.lambda.invoke_arn}"
# }

# resource "aws_api_gateway_deployment" "model_serving_api" {
#   depends_on = [
#     "aws_api_gateway_integration.lambda",
#     "aws_api_gateway_integration.lambda_root",
#   ]

#   rest_api_id = "${aws_api_gateway_rest_api.model_serving_api.id}"
#   stage_name  = "${var.stage}"
# }