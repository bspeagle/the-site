output "ecsIAMrole_name" {
  value = "${aws_iam_role.ecsIAMrole.name}"
}

output "ecsIAMtaskrole_arn" {
  value = "${aws_iam_role.ecsIAMtaskrole.arn}"
}

output "ecsIAMsvcrole_arn" {
  value = "${aws_iam_role.ecsIAMsvcrole.arn}"
}

output "ecsIAMrole_profile_name" {
  value = "${aws_iam_instance_profile.ecsIAMrole.name}"
}