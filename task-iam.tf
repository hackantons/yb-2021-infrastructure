resource "aws_iam_role" "role_for_ybhackathon_backend_task" {
  name = "RoleForYBHackathon2021BackendTask"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "task_policy" {
  name       = "tasks-policy"
  roles      = [aws_iam_role.role_for_ybhackathon_backend_task.name]
  policy_arn = aws_iam_policy.task_ybhackathon.arn
}

resource "aws_iam_policy" "task_ybhackathon" {
  name        = "TaskYBHackathon2021Policy"
  description = "This policy provides the ybhackathon task to access specific AWS resources."

  policy = data.aws_iam_policy_document.task.json
}

data "aws_iam_policy_document" "task" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
}