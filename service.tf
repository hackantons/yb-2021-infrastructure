resource "aws_ecs_service" "ybhackathon_service" {
  name        = "ybhackathon-2021-backend-service"
  cluster     = aws_ecs_cluster.ybhackathon.id
  #launch_type = "FARGATE"

  task_definition = "ybhackathon-2021-backend"

  desired_count = 1

  capacity_provider_strategy {
      capacity_provider = "FARGATE_SPOT"
      weight            = 99
  }

  capacity_provider_strategy {
      capacity_provider = "FARGATE"
      weight            = 1
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ybhackathon.arn
    container_name   = "ybhackathon-2021-backend"
    container_port   = 3000
  }

  network_configuration {
    subnets          = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  lifecycle {
    #ignore_changes = [desired_count, task_definition]
    ignore_changes = [task_definition]
  }

  depends_on = [
    aws_alb_listener.backend
  ]
}

resource "aws_security_group" "ecs_tasks" {
  name        = "ybhackathon-fargate-tasks"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.ybhackathon_vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    security_groups = [aws_security_group.alb_ybhackathon.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
