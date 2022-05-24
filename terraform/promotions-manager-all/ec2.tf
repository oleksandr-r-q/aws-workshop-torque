data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "promotions-manager" {
  ami        = data.aws_ami.ubuntu.id
  private_ip = "10.0.101.100"
  instance_type = var.instance_type

  iam_instance_profile = var.instance_profile != "" ? var.instance_profile : "promotions-manager-${var.env}"
  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  vpc_security_group_ids = [var.aws_security_group_id]
  subnet_id = var.public_subnet

  # user_data = data.template_cloudinit_config.promotions-manager.rendered

    user_data = templatefile("mongodb.sh", { S3 = var.aws_s3_bucket, ARTIFACTS_PATH = "/tmp/${var.artifacts_path_mongodb}"})
  tags = {
    Name = "promotions-manager-${var.SANDBOX_ID}"
  }
}


# data "template_cloudinit_config" "promotions-manager" {
#   gzip          = true
#   base64_encode = true

#   # artifacts
#   part {
#     content = templatefile(
#       "${path.module}/templates/artifacts.sh",
#       {
#         S3  = var.aws_s3_bucket,
#         ARTIFACTS_PATH = "/tmp"
#       }
#     )
#   }

#   # mongodb
#   part {
#     content = templatefile(
#       "${path.module}/templates/mongodb.sh",
#       {
#         S3  = var.aws_s3_bucket,
#         ARTIFACTS_PATH = "/tmp/${var.artifacts_path_mongodb}"
#       }
#     )
#   }

#   # promotions-manager-api
#   part {
#     content = templatefile(
#       "${path.module}/templates/promotions-manager-api.sh",
#       {
#         S3  = var.aws_s3_bucket,
#         ARTIFACTS_PATH = "/tmp/${var.artifacts_path_promotions-manager-api}",
#         DATABASE_HOST  = "127.0.0.1",
#         RELEASE_NUMBER = var.RELEASE_NUMBER,
#         API_BUILD_NUMBER = var.API_BUILD_NUMBER,
#         API_PORT = var.API_PORT,
#         PORT = var.PORT
#       }
#     )
#   }

#     # promotions-manager-ui
#   part {
#     content = templatefile(
#       "${path.module}/templates/promotions-manager-ui.sh",
#       {
#         S3  = var.aws_s3_bucket,
#         ARTIFACTS_PATH = "/tmp/${var.artifacts_path_promotions-manager-ui}",
#         API_PORT = var.API_PORT,
#         PORT = var.PORT
#       }
#     )
#   }
# }

# artifacts:
#   - promotions-manager-ui: artifacts/latest/promotions-manager-ui.master.tar.gz
#   - promotions-manager-api: artifacts/latest/promotions-manager-api.master.tar.gz
#   - mongodb: artifacts/test-data/test-data-db.tar


# 022-05-23 15:38:28,492 - subp.py[DEBUG]: Running command ['/var/lib/cloud/instance/scripts/part-001'] with allowed return codes [0] (shell=False, capture=False)
# 2022-05-23 15:38:28,504 - subp.py[DEBUG]: Unexpected error while running command.
# Command: ['/var/lib/cloud/instance/scripts/part-001']
# Exit code: 127
# Reason: -
# Stdout: -
# Stderr: -
# 2022-05-23 15:38:28,504 - subp.py[DEBUG]: Running command ['/var/lib/cloud/instance/scripts/part-002'] with allowed return codes [0] (shell=False, capture=False)
# 2022-05-23 15:39:17,797 - subp.py[DEBUG]: Unexpected error while running command.
# Command: ['/var/lib/cloud/instance/scripts/part-002']
# Exit code: 5
# Reason: -
# Stdout: -
# Stderr: -
# 2022-05-23 15:39:17,798 - subp.py[DEBUG]: Running command ['/var/lib/cloud/instance/scripts/part-003'] with allowed return codes [0] (shell=False, capture=False)
# 2022-05-23 15:40:13,503 - subp.py[DEBUG]: Running command ['/var/lib/cloud/instance/scripts/part-004'] with allowed return codes [0] (shell=False, capture=False)
# 2022-05-23 15:41:05,717 - subp.py[DEBUG]: Unexpected error while running command.
# Command: ['/var/lib/cloud/instance/scripts/part-004']
# Exit code: 1
# Reason: -
# Stdout: -
# Stderr: -
# 2022-05-23 15:41:05,717 - cc_scripts_user.py[WARNING]: Failed to run module scripts-user (scripts in /var/lib/cloud/instance/scripts)
# 2022-05-23 15:41:05,718 - handlers.py[DEBUG]: finish: modules-final/config-scripts-user: FAIL: running config-scripts-user with frequency once-per-instance
# 2022-05-23 15:41:05,718 - util.py[WARNING]: Running module scripts-user (<module 'cloudinit.config.cc_scripts_user' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_scripts_user.py'>) failed
# 2022-05-23 15:41:05,719 - util.py[DEBUG]: Running module scripts-user (<module 'cloudinit.config.cc_scripts_user' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_scripts_user.py'>) failed
# Traceback (most recent call last):