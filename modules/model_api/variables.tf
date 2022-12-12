variable "stage" {
  description = "The stage of the environment (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy the resources"
}

variable "log_level" {
  description = "The log level for the lambda function"
  default     = "INFO"
}

variable "model_name" {
  description = "The name of the ML model"
}

variable "model_endpoint_name" {
  description = "The name of the ML model endpoint"
}
