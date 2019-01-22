output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "snELB1_id" {
  value = "${aws_subnet.snELB1.id}"
}

output "snELB2_id" {
  value = "${aws_subnet.snELB2.id}"
}

output "snAPP1_id" {
  value = "${aws_subnet.snAPP1.id}"
}

output "snAPP2_id" {
  value = "${aws_subnet.snAPP2.id}"
}