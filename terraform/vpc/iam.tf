resource "aws_iam_instance_profile" "promotions-manager" {
  name = "promotions-manager-${var.SANDBOX_ID}"
  role = aws_iam_role.promotions-manager.name
}

#SSM

resource "aws_iam_role" "promotions-manager" {
  name = "promotions-manager-${var.SANDBOX_ID}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
      "Service": "ec2.amazonaws.com",
      "Service": "ssm.amazonaws.com"
    },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "promotions-manager-ssm" {
  role       = aws_iam_role.promotions-manager.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "promotions-manager-s3" {
  role       = aws_iam_role.promotions-manager.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


resource "aws_ssm_activation" "promotions-manager-ssm-activation" {
  depends_on  = [aws_iam_role_policy_attachment.promotions-manager-ssm]
  name        = "promotions-manager-${var.SANDBOX_ID}"
  description = "tableau_epromotions-manager"
  iam_role    = aws_iam_role.promotions-manager.id
  # registration_limit = "5"
}


