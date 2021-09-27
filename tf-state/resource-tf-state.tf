resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = var.s3_bucket_name

  versioning {
    enabled = true
  }

}


resource "aws_dynamodb_table" "tf_state_dynamo_db" {
  name             = var.dynamo_db_table_name
  hash_key         = "LockID"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "LockID"
    type = "S"
  }

  replica {
    region_name = "us-east-1"
  }
}