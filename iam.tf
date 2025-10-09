resource "aws_iam_role" "admin_role" {
  name = "admin_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "admin-role"
  }
}

locals {
  map_roles = [
    {
      rolearn  = aws_iam_role.admin_role.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["cluster-admin"]
    }
  ]
}