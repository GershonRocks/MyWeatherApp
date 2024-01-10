provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_s3_bucket" "my_weather_app_bucket" {
    bucket = "your_s3_bucket_name"

    tags = {
        Name        = "My Weather App Bucket"
        Environment = "Development"
    }
}

resource "aws_lambda_function" "my_weather_app" {
  function_name = "MyWeatherApp"
  role          = aws_iam_role.lambda_role.arn

  // Assuming the code is zipped and uploaded to an S3 bucket
  s3_bucket = "your_s3_bucket_name"
  s3_key    = "your_s3_key.zip"

  handler = "handler.js" // Update with the actual handler
  runtime = "nodejs20.x"    // Update with the actual Node.js runtime version
}


