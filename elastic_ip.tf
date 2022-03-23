# Create Elastic IP address
resource "aws_eip" "JenkinsInstance" {
  vpc = true
  instance = aws_instance.jenkins.id
  tags = {
 "Name" = "jenkins_elastic_ip"
 }
}

resource "aws_eip" "AnsibleControllerInstance" {
  vpc = true
  instance = aws_instance.ansible.id
  tags = {
 "Name" = "Ansible_controller_ip"
 }
}

