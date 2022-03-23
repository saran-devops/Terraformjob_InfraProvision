pipeline {
     
   environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
 
   agent any
    
    tools {
        terraform 'terraform'
    }
    stages {
        stage ("checkout from GIT") {
            steps {
             git branch: 'master', credentialsId: 'saranlang', url: 'https://github.com/saran-devops/Terraform-Jenkins-032022.git'
            }
        }
        stage ("terraform init") {
            steps {
                sh 'terraform init'
            }
        }
        stage ("terraform fmt") {
            steps {
                sh 'terraform fmt'
            }
        }
        stage ("terraform validate") {
            steps {
                sh 'terraform validate'
            }
        }
        stage ("terrafrom plan") {
            steps {
                sh 'terraform plan '
            }
        }
        stage ("terraform Action") {
            steps {
                echo "Terraform action is --> ${action}"
                sh ('terraform ${action} --auto-approve') 
        }
    }
 }
}
