# Configure AWS provider
provider "aws" {
  region = "us-east-1" 
}




resource "aws_s3_bucket_acl" "surfline_data_bucket" {
  bucket = "surfline-data-bucket"
  acl    = "private"
}

resource "aws_iam_role" "lambda_role" {
  name = "surfline-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  name       = "surfline-lambda-attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" 
}

# Create Lambda function
resource "aws_lambda_function" "surfline_lambda" {
  function_name = "surfline-data-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main.lambda_handler" # 
  runtime       = "python3.8"           

  # Replace with your Lambda function code file
  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
}






resource "aws_cloudwatch_event_rule" "surfline_event_rule" {
  name                = "surfline-event-rule"
  description         = "Event rule for Surfline"
  schedule_expression = "cron(0 * * * ? *)" 


}

resource "aws_cloudwatch_event_target" "surfline_event_target" {
  rule      = aws_cloudwatch_event_rule.surfline_event_rule.name
  arn       = aws_lambda_function.surfline_lambda.arn
  target_id = "surfline-lambda-target"

}



resource "aws_lambda_permission" "surfline_lambda_permission" {
  statement_id  = "surfline-lambda-permission"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.surfline_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.surfline_event_rule.arn
}
