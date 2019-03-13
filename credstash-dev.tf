resource "aws_iam_policy" "credstash_dev" {
  name_prefix        = "credstash-dev-"
  description = "Permissions for people who can perform put, get secrets with encryption context role=dev"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kms:GenerateDataKey",
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Resource": "${aws_kms_key.master_key.arn}",
      "Condition": {
        "StringEquals": {
          "kms:EncryptionContext:role": "dev"
        }
      }
    },
    {
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ],
      "Effect": "Allow",
      "Resource": "${aws_dynamodb_table.crendential_store.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_group" "credstash_dev" {
  name = "credstash-dev"
}

resource "aws_iam_group_policy_attachment" "credstash_dev" {
  group      = "${aws_iam_group.credstash_dev.name}"
  policy_arn = "${aws_iam_policy.credstash_dev.arn}"
}

resource "aws_iam_user" "credstash_dev" {
  name = "credstash-dev"
}

resource "aws_iam_access_key" "credstash_dev" {
  user    = "${aws_iam_user.credstash_dev.name}"
}

resource "aws_iam_user_group_membership" "credstash_dev" {
  user = "${aws_iam_user.credstash_dev.name}"

  groups = [
    "${aws_iam_group.credstash_dev.name}"
  ]
}

output "credstash_dev_access_key" {
  value = "${aws_iam_access_key.credstash_dev.id}"
}
output "credstash_dev_secret_key" {
  value = "${aws_iam_access_key.credstash_dev.secret}"
}
