output "aws_security_group_jenkins_server_details" {
  value = aws_security_group.external_traffic
}

output "jenkins_ip_address" {
  value = aws_instance.jenkins.public_ip
}

output "subnet_ec2_instance" {
  value = aws_instance.jenkins.subnet_id
}

output "ansible_ip_address" {
  value = aws_instance.ansible.public_ip
}

output "ansible_public_dns" {
  value = aws_instance.ansible.public_dns
}
