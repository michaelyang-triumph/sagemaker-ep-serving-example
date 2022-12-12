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
