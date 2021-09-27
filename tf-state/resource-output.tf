output "S3_bucket_name" {
  value = aws_s3_bucket.tf_state_bucket.id
}

output "S3_bucket_arn" {
  value = aws_s3_bucket.tf_state_bucket.arn
}

output "dynamob_db_table" {
  value = aws_dynamodb_table.tf_state_dynamo_db.id
}