provider "aws" {
  region = "${var.region}"
}

resource "aws_kms_key" "master_key" {
  description = "Master key for credstash"
  tags = "${var.tags}"
}

resource "aws_kms_alias" "credstash" {
  name = "alias/credstash"
  target_key_id = "${aws_kms_key.master_key.id}"
}

resource "aws_dynamodb_table" "crendential_store" {
  name = "${var.table_name}"
  read_capacity  = "${var.dynamodb_read_capacity}"
  write_capacity = "${var.dynamodb_write_capacity}"
  hash_key       = "name"
  range_key      = "version"

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "version"
    type = "S"
  }

  tags = "${var.tags}"
}
