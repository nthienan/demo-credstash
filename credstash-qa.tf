resource "aws_iam_policy" "credstash_qa" {
  name_prefix        = "credstash-qa-"
  description = "Permissions for people who can perform put, get secrets with encryption context role=qa"

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
          "kms:EncryptionContext:role": "qa"
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

resource "aws_iam_group" "credstash_qa" {
  name = "credstash-qa"
}

resource "aws_iam_group_policy_attachment" "credstash_qa" {
  group      = "${aws_iam_group.credstash_qa.name}"
  policy_arn = "${aws_iam_policy.credstash_qa.arn}"
}

resource "aws_iam_user" "credstash_qa" {
  name = "credstash-qa"
}

resource "aws_iam_access_key" "credstash_qa" {
  user    = "${aws_iam_user.credstash_qa.name}"
}

resource "aws_iam_user_group_membership" "credstash_qa" {
  user = "${aws_iam_user.credstash_qa.name}"

  groups = [
    "${aws_iam_group.credstash_qa.name}"
  ]
}

output "credstash_qa_access_key" {
  value = "${aws_iam_access_key.credstash_qa.id}"
}
output "credstash_qa_secret_key" {
  value = "${aws_iam_access_key.credstash_qa.secret}"
}
