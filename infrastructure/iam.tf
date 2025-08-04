resource "aws_iam_role" "k8s" {
  name = "k8s-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "k8s" {
  role       = aws_iam_role.k8s.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
