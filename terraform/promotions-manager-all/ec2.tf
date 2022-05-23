data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "promotions-manager-ui" {
  ami        = data.aws_ami.ubuntu.id
  private_ip = "10.0.1.100"
  instance_type = var.instance_type

  iam_instance_profile = var.instance_profile != "" ? var.instance_profile : "promotions-manager-${var.env}"
  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  vpc_security_group_ids = [var.aws_security_group_id]
  subnet_id = var.public_subnet

  user_data = data.template_cloudinit_config.promotions-manager.rendered
  tags = {
    name = "promotions-manager-${var.SANDBOX_ID}"
  }
}


data "template_cloudinit_config" "promotions-manager" {
  gzip          = true
  base64_encode = true

  # artifacts
  part {
    content = templatefile(
      "${path.module}/templates/artifacts.sh",
      {
        S3  = var.aws_s3_bucket,
        ARTIFACTS_PATH = "/tmp"
      }
    )
  }

  # mongodb
  part {
    content = templatefile(
      "${path.module}/templates/mongodb.sh",
      {
        S3  = var.aws_s3_bucket,
        ARTIFACTS_PATH = "/tmp/${var.artifacts_path_mongodb}"
      }
    )
  }

  # promotions-manager-api
  part {
    content = templatefile(
      "${path.module}/templates/promotions-manager-api.sh",
      {
        S3  = var.aws_s3_bucket,
        ARTIFACTS_PATH = "/tmp/${var.artifacts_path_promotions-manager-api}"
      }
    )
  }

    # promotions-manager-ui
  part {
    content = templatefile(
      "${path.module}/templates/promotions-manager-ui.sh",
      {
        S3  = var.aws_s3_bucket,
        ARTIFACTS_PATH = "/tmp/${var.artifacts_path_promotions-manager-ui}"
      }
    )
  }
}

# artifacts:
#   - promotions-manager-ui: artifacts/latest/promotions-manager-ui.master.tar.gz
#   - promotions-manager-api: artifacts/latest/promotions-manager-api.master.tar.gz
#   - mongodb: artifacts/test-data/test-data-db.tar