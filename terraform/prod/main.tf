variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "zone_id" {}
variable "record_name" {}
variable "key_name" {}

variable "app" {
  default = "the-site"
}

variable "env" {
  default = "PROD"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "vpc" {
  source = "../modules/vpc"
  app = "${var.app}"
  env = "${var.env}"
}

module "secGroups" {
  source = "../modules/secGroups"
  app = "${var.app}"
  env = "${var.env}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "iAM" {
  source = "../modules/iAM"
  app = "${var.app}"
  env = "${var.env}"
}

module "ecs" {
  source = "../modules/ecs"
  app = "${var.app}"
  env = "${var.env}"
  vpc_id = "${module.vpc.vpc_id}"
  snELB1_id = "${module.vpc.snELB1_id}"
  snELB2_id = "${module.vpc.snELB2_id}"
  snAPP1_id = "${module.vpc.snAPP1_id}"
  snAPP2_id = "${module.vpc.snAPP2_id}"
  ec2sg_id = "${module.secGroups.ec2sg_id}"
  lbsg_id = "${module.secGroups.lbsg_id}"
  ecsIAMrole_name = "${module.iAM.ecsIAMrole_name}"
  ecsIAMtaskrole_arn = "${module.iAM.ecsIAMtaskrole_arn}"
  ecsIAMsvcrole_arn = "${module.iAM.ecsIAMsvcrole_arn}"
  ecsIAMrole_profile_name = "${module.iAM.ecsIAMrole_profile_name}"
  key_name = "${var.key_name}"
}

module "route53" {
  source = "../modules/route53"
  app = "${var.app}"
  env = "${var.env}"
  zone_id = "${var.zone_id}"
  record_name = "${var.record_name}"
  lb-zoneId = "${module.ecs.lb-zoneId}"
  lb-dns = "${module.ecs.lb-dns}"
}

// module "bastion" {
//   source = "../modules/bastion"
//   app = "${var.app}"
//   env = "${var.env}"
//   snELB1_id = "${module.vpc.snELB1_id}"
//   bastionsg_id = "${module.secGroups.bastionsg_id}"
//   key_name = "${var.key_name}"
// }