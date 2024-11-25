resource "aws_iam_policy_attachment" "redpanda" {
  count      = var.tiered_storage_enabled ? 1 : 0
  name       = local.deployment_id
  roles      = [aws_iam_role.redpanda[count.index].name]
  policy_arn = aws_iam_policy.redpanda[count.index].arn
}

resource "aws_iam_instance_profile" "redpanda" {
  count = var.tiered_storage_enabled ? 1 : 0
  name  = local.deployment_id
  role  = aws_iam_role.redpanda[count.index].name
}

resource "aws_iam_policy" "redpanda" {
  count = var.tiered_storage_enabled ? 1 : 0
  name  = local.deployment_id
  path  = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*",
          "s3-object-lambda:*",
        ],
        "Resource" : [
          "arn:aws:s3:::${local.tiered_storage_bucket_name}/*",
          "arn:aws:s3:::${local.tiered_storage_bucket_name}"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "redpanda" {
  count = var.tiered_storage_enabled ? 1 : 0
  name  = local.deployment_id
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_s3_bucket" "tiered_storage" {
  count         = var.tiered_storage_enabled ? 1 : 0
  bucket        = local.tiered_storage_bucket_name
  tags          = local.instance_tags
  force_destroy = var.allow_force_destroy
}

resource "aws_s3_bucket_versioning" "tiered_storage" {
  count  = var.tiered_storage_enabled ? 1 : 0
  bucket = aws_s3_bucket.tiered_storage[count.index].id
  versioning_configuration {
    status = "Disabled"
  }
}
