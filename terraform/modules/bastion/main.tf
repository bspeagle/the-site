resource "aws_instance" "ec2_bastion" {
  ami = "ami-01e3b8c3a51e88954"
  instance_type = "t2.micro"
  subnet_id = "${var.snELB1_id}"
  vpc_security_group_ids = ["${var.bastionsg_id}"]
  key_name = "${var.key_name}"

  tags {
    Name = "${var.app}-${var.env}-BASTION"
    App = "${var.app}"
    Env = "${var.env}"
  }
}