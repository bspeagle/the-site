output "lbsg_id" {
  value = "${aws_security_group.lbsg.id}"
}

output "ec2sg_id" {
  value = "${aws_security_group.ec2sg.id}"
}

// output "bastionsg_id" {
//   value = "${aws_security_group.bastion_sg.id}"
// }