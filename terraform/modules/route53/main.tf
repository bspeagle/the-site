variable "app" {}
variable "env" {}
variable "zone_id" {}
variable "record_name" {}
variable "lb-zoneId" {}
variable "lb-dns" {}

resource "aws_route53_record" "www" {
  zone_id = "${var.zone_id}"
  name = "${var.record_name}"
  type = "A"
  
  alias {
    name = "${var.lb-dns}"
    zone_id = "${var.lb-zoneId}"
    evaluate_target_health = true
  }
}