resource "aws_lb_target_group" "lb-tg-web" {
  name     = "${var.app}-TG-WEB-${var.env}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  tags {
    Name = "${var.app}-TG-WEB-${var.env}"
    App  = "${var.app}"
    Env  = "${var.env}"
  }
}

resource "aws_lb" "lb-web" {
  name               = "${var.app}-LB-WEB-${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.lbsg_id}"]

  subnets = [
    "${var.snELB1_id}",
    "${var.snELB2_id}",
  ]

  tags {
    Name = "${var.app}-LB-WEB-${var.env}"
    App  = "${var.app}"
    Env  = "${var.env}"
  }
}

resource "aws_lb_listener" "forward" {
  load_balancer_arn = "${aws_lb.lb-web.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.lb-tg-web.arn}"
    type             = "forward"
  }
}

resource "aws_ecs_cluster" "cluster1" {
  name = "${var.app}-${var.env}"
}

resource "aws_instance" "ec2_A" {
  ami = "ami-06bec82fb46167b4f"
  instance_type = "t2.micro"
  subnet_id = "${var.snAPP1_id}"
  vpc_security_group_ids = ["${var.ec2sg_id}"]
  iam_instance_profile = "${var.ecsIAMrole_profile_name}"
  key_name = "${var.key_name}"

  user_data = <<EOF
    #!/bin/bash
    echo ECS_CLUSTER=${aws_ecs_cluster.cluster1.name} >> /etc/ecs/ecs.config
  EOF

  tags {
    Name = "${var.app}-${var.env}-ECS"
    App = "${var.app}"
    Env = "${var.env}"
  }
}

resource "aws_ecs_task_definition" "deploy_app" {
  family                = "app_deploy-${var.env}"
  //network_mode          = "host"
  task_role_arn         = "${var.ecsIAMtaskrole_arn}"
  container_definitions = "${file("../files/service.json")}"
}

resource "aws_ecs_service" "qppDeploy" {
  name            = "${var.app}-App-Deploy"
  cluster         = "${aws_ecs_cluster.cluster1.id}"
  task_definition = "${aws_ecs_task_definition.deploy_app.arn}"
  desired_count   = 1
  iam_role        = "${var.ecsIAMsvcrole_arn}"

  load_balancer {
    target_group_arn = "${aws_lb_target_group.lb-tg-web.arn}"
    container_name   = "${var.app}"
    container_port   = 80
  }

  depends_on = ["aws_instance.ec2_A", "aws_lb.lb-web"]
}