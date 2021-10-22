resource "aws_ecs_cluster" "ybhackathon" {
  name = "ybhackathon-2021"

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]  

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecr_repository" "ybhackathon" {
  name = "ybhackathon-2021"
}
