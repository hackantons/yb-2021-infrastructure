resource "aws_ecs_cluster" "ybhackathon" {
  name = "ybhackathon-2021"
}

resource "aws_ecr_repository" "ybhackathon" {
  name = "ybhackathon-2021"
}
