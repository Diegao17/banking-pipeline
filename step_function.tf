resource "aws_iam_role" "step_function_role" {
  name = "step_function_role_pipeline"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "states.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "step_function_policy" {
  role = aws_iam_role.step_function_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "lambda:InvokeFunction"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_sfn_state_machine" "pipeline" {
  name     = "banking_pipeline"
  role_arn = aws_iam_role.step_function_role.arn

  definition = jsonencode({
    StartAt = "Validate",
    States = {

      Validate = {
        Type = "Task",
        Resource = module.validate_lambda.lambda_arn,
        Next = "Risk"
      },

      Risk = {
        Type = "Task",
        Resource = module.risk_lambda.lambda_arn,
        Next = "Choice"
      },

      Choice = {
        Type = "Choice",
        Choices = [
          {
            Variable = "$.risk_level",
            StringEquals = "high",
            Next = "RouteReview"
          }
        ],
        Default = "RouteApproved"
      },

      RouteReview = {
        Type = "Task",
        Resource = module.route_lambda.lambda_arn,
        End = true
      },

      RouteApproved = {
        Type = "Task",
        Resource = module.route_lambda.lambda_arn,
        End = true
      }

    }
  })
}