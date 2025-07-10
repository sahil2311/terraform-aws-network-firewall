resource "aws_flow_log" "aws_flow_log" {
  log_destination      = aws_s3_bucket.aws_s3_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id
}

resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket        = "${var.environment}-vpc-logs-${data.aws_caller_identity.account.account_id}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "aws_s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.aws_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}