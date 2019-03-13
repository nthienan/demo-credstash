resource "aws_iam_policy" "credstash_reader" {
  name_prefix        = "credstash-reader-"
  description = "Permissions for people who can perform get secrets"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Resource": "${aws_kms_key.master_key.arn}"
    },
    {
      "Action": [
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

resource "aws_iam_group" "credstash_reader" {
  name = "credstash-reader"
}

resource "aws_iam_group_policy_attachment" "credstash_reader" {
  group      = "${aws_iam_group.credstash_reader.name}"
  policy_arn = "${aws_iam_policy.credstash_reader.arn}"
}

resource "aws_iam_user" "credstash_reader" {
  name = "credstash-reader"
}

resource "aws_iam_access_key" "credstash_reader" {
  user    = "${aws_iam_user.credstash_reader.name}"
}

resource "aws_iam_user_group_membership" "credstash_reader" {
  user = "${aws_iam_user.credstash_reader.name}"

  groups = [
    "${aws_iam_group.credstash_reader.name}"
  ]
}

output "credstash_reader_access_key" {
  value = "${aws_iam_access_key.credstash_reader.id}"
}
output "credstash_reader_secret_key" {
  value = "${aws_iam_access_key.credstash_reader.secret}"
}
