# COPY AMI FROM MUMBAI → TARGET REGION

resource "aws_ami_copy" "hysecure" {
  name              = "hysecure-${var.aws_region}"
  description       = "Copied from Mumbai AMI"

  source_ami_id     = var.source_ami_id
  source_ami_region = "ap-south-1"

  tags = {
    Name = "hysecure-${var.aws_region}"
  }
}