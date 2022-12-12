variable "stage" {
  description = "Deployment stage"
  default     = "dev"
}

variable "aws_region" {
  description = "The AWS region to deploy the resources"
  default     = "us-east-2"
}

variable "log_level" {
  description = "The log level for the lambda function"
  default     = "INFO"
}

variable "model_name" {
  description = "The name of model endpoint is serving"
  default     = "document"
}

variable "model_endpoint_name" {
  description = "The name of the ML model endpoint"
  default     = "ml-demo-2022-12-11-19-30-34-1670787066-ep"
}