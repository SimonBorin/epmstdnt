resource "aws_iam_role" "iam_for_lambda_start_stop" {
  name = "iam_for_lambda_start_stop"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEC2FullAccess-attachment" {
    role = aws_iam_role.iam_for_lambda_start_stop.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
#########################
# Start instanses block #
#########################

data "archive_file" "starter" {
    type          = "zip"
    source_file   = "${path.module}/files/start.py"
    output_path   = "${path.module}/start.zip"
}

resource "aws_lambda_function" "starter" {
  filename      = "start.zip"
  function_name = "lambda_handler_starter"
  role          = aws_iam_role.iam_for_lambda_start_stop.arn
  handler       = "start.lambda_handler"

  source_code_hash = filebase64sha256("start.zip")

  runtime = "python3.6"

  environment {
    variables = {
      instanses = aws_instance.ec2-module1.id
      region    = var.region
    }
  }
}

resource "aws_cloudwatch_event_rule" "starter" {
  name                = "ec2-starter"
  description         = "start ec2 by trigger"
  schedule_expression = "cron(0 9 * * ? *)" # UTC time
}

resource "aws_cloudwatch_event_target" "starter" {
  rule      = aws_cloudwatch_event_rule.starter.name
  target_id = "lambda-starter"
  arn       = aws_lambda_function.starter.arn
}

resource "aws_lambda_permission" "allow_start" {
  statement_id  = "AllowExecutionFromCloudWatchStarter"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.starter.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.starter.arn
}

########################
# Stop Instanses block #
########################

data "archive_file" "stopper" {
    type          = "zip"
    source_file   = "${path.module}/files/stop.py"
    output_path   = "${path.module}/stop.zip"
}

resource "aws_lambda_function" "stopper" {
  filename      = "stop.zip"
  function_name = "lambda_handler_stopper"
  role          = aws_iam_role.iam_for_lambda_start_stop.arn
  handler       = "stop.lambda_handler"

  source_code_hash = filebase64sha256("stop.zip")

  runtime = "python3.6"

  environment {
    variables = {
      instanses = aws_instance.ec2-module1.id
      region    = var.region
    }
  }
}

resource "aws_cloudwatch_event_rule" "stopper" {
  name                = "ec2-stopper"
  description         = "stops ec2 by trigger"
  schedule_expression = "cron(0 23 * * ? *)" # UTC time
}

resource "aws_cloudwatch_event_target" "stopper" {
  rule      = aws_cloudwatch_event_rule.stopper.name
  target_id = "lambda-stopper"
  arn       = aws_lambda_function.stopper.arn
}

resource "aws_lambda_permission" "allow_stop" {
  statement_id  = "AllowExecutionFromCloudWatchStopper"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stopper.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stopper.arn
}
