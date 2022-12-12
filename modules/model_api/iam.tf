resource "aws_iam_role" "model_serving_lambda_role" {
  name               = "${local.lambda_iam_role_name}"
  assume_role_policy = <<-ROLE
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  ROLE
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${local.lambda_iam_policy_name}"
  path        = "/"
  description = "IAM policy for Model Serving Lambda"

  policy = <<-POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*",
        "Effect": "Allow"
      },
      {
          "Effect": "Allow",
          "Action": "sagemaker:InvokeEndpoint",
          "Resource": "*"
      }
    ]
  }
  POLICY
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.model_serving_lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}