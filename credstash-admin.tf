resource "aws_iam_policy" "credstash_admin" {
  name_prefix        = "credstash-admin-"
  description = "Permissions for credstash admin that can perform setup, put, and delete secrets"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:CreateTable",
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "${aws_dynamodb_table.crendential_store.arn}"
    },
    {
      "Effect": "Allow",
      "Action": "dynamodb:ListTables",
      "Resource": "*"
    },
    {
      "Action": [
        "kms:GenerateDataKey",
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Resource": "${aws_kms_key.master_key.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_group" "credstash_admin" {
  name = "credstash-admin"
}

resource "aws_iam_group_policy_attachment" "credstash_admin" {
  group      = "${aws_iam_group.credstash_admin.name}"
  policy_arn = "${aws_iam_policy.credstash_admin.arn}"
}

resource "aws_iam_user" "credstash_admin" {
  name = "credstash-admin"
}

resource "aws_iam_access_key" "credstash_admin" {
  user    = "${aws_iam_user.credstash_admin.name}"
}

resource "aws_iam_user_group_membership" "credstash_admin" {
  user = "${aws_iam_user.credstash_admin.name}"

  groups = [
    "${aws_iam_group.credstash_admin.name}"
  ]
}

output "credstash_admin_access_key" {
  value = "${aws_iam_access_key.credstash_admin.id}"
}
output "credstash_admin_secret_key" {
  value = "${aws_iam_access_key.credstash_admin.secret}"
}

