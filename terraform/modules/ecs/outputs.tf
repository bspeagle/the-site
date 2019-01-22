output "lb-zoneId" {
  value = "${aws_lb.lb-web.zone_id}"
}

output "lb-dns" {
  value = "${aws_lb.lb-web.dns_name}"
}