# Terraformjob_InfraProvision
This repo is for provisioning the Jenkins and Ansible servers for the CICD Pipelines

****************************
Prerequisites
****************************
Ubuntu EC2 Instance.
Security Group with Port 8080 open for internet
Java 11 should be installed
Install Jenkins using apt-get package manager
Setting up the jenkins key and repo for the jenkins installation and future reference
Get the latest version of jenkins from https://pkg.jenkins.io/debian-stable/jenkins.io.key  and install
echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list

***************************
Installation:
****************************
sudo apt install -y openjdk-11-jdk
sudo apt update
sudo apt install -y jenkins

***********************
Start Jenkins
*********************
# Start jenkins service
sudo systemctl start jenkins

# Setup Jenkins to start at boot,

By default jenkins runs at port 8080, You can access jenkins at

http://<Elastic_IP>:8080
*******************************
Post Installation Steps:
******************************* 
Configure Jenkins
The default Username is admin
Grab the default password
Password Location:/var/lib/jenkins/secrets/initialAdminPassword
Change admin password
Admin > Configure > Password
Configure java path
Manage Jenkins > Global Tool Configuration > JDK
Create another admin user id
Test Jenkins Jobs
Create “new item”
Enter an item name – My-First-Project
Chose Freestyle project
Under the Build section Execute shell: echo "Welcome to Jenkins Demo"
Save your job
Build job
Check "console output"

2) Terraform script to provision the AnsibleController node
*************************
Pre-requiste
*************************
Ansible is an open-source automation platform.  Ansible can help you with configuration management, application deployment, task automation.
*********************
Pre-requisites
********************
Ubuntu Ec2 instance in aws cloud with t2.large machine type.
Installation steps:
on Amazon EC2 instance
Install python and python-pip

sudo apt-get install -y python3-pip
sudo pip3 install awscli
sudo pip3 install boto boto3
ansible --version
Create a user called ansadmin (on Control node and Managed host-Kubernetes cluster)

useradd ansadmin
passwd ansadmin
Below command grant sudo access to ansadmin user. 

echo "ansadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
Log in as a ansadmin user on master and generate ssh key (on Control node)

sudo su - ansadmin
ssh-keygen
Copy keys onto all ansible managed hosts (on Control node)

ssh-copy-id ansadmin@<target-server>
Ansible server used to create images and store on docker registry. 
****************
Validation test:
**************
Run ansible command as ansadmin user it should be successful (Master)
ansible all -m ping



