resource "aws_lambda_function" "this" {
  function_name = var.function_name
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = var.role_arn

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_path
  output_path = "${path.module}/${var.function_name}.zip"
}