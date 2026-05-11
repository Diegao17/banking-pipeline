provider "aws" {
  region = "us-east-1"
}

module "validate_lambda" {
  source        = "./modules/lambda_function"
  function_name = "validate_lambda"
  source_path   = "${path.module}/lambdas/validate"
  role_arn      = aws_iam_role.lambda_role.arn

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_iam_role_policy_attachment.lambda_s3
  ]
}

module "risk_lambda" {
  source        = "./modules/lambda_function"
  function_name = "risk_lambda"
  source_path   = "${path.module}/lambdas/risk"
  role_arn      = aws_iam_role.lambda_role.arn

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_iam_role_policy_attachment.lambda_s3
  ]
}

module "route_lambda" {
  source        = "./modules/lambda_function"
  function_name = "route_lambda"
  source_path   = "${path.module}/lambdas/route"
  role_arn      = aws_iam_role.lambda_role.arn

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_iam_role_policy_attachment.lambda_s3
  ]
}

resource "aws_s3_bucket" "pipeline_bucket" {
  bucket = "mi-bucket-pipeline-diego-12345"
}