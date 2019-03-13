resource "aws_iam_policy" "credstash_writer" {
  name_prefix        = "credstash-writer-"
  description = "Permissions for people who can perform put secrets"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kms:GenerateDataKey"
      ],
      "Effect": "Allow",
      "Resource": "${aws_kms_key.master_key.arn}"
    },
    {
      "Action": [
        "dynamodb:Query",
        "dynamodb:PutItem"
      ],
      "Effect": "Allow",
      "Resource": "${aws_dynamodb_table.crendential_store.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_group" "credstash_writer" {
  name = "credstash-writer"
}

resource "aws_iam_group_policy_attachment" "credstash_writer" {
  group      = "${aws_iam_group.credstash_writer.name}"
  policy_arn = "${aws_iam_policy.credstash_writer.arn}"
}

resource "aws_iam_user" "credstash_writer" {
  name = "credstash-writer"
}

resource "aws_iam_access_key" "credstash_writer" {
  user    = "${aws_iam_user.credstash_writer.name}"
}

resource "aws_iam_user_group_membership" "credstash_writer" {
  user = "${aws_iam_user.credstash_writer.name}"

  groups = [
    "${aws_iam_group.credstash_writer.name}"
  ]
}

output "credstash_writer_access_key" {
  value = "${aws_iam_access_key.credstash_writer.id}"
}
output "credstash_writer_secret_key" {
  value = "${aws_iam_access_key.credstash_writer.secret}"
}
