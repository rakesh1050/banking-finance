pipeline {
  agent any
     tools {
       maven 'M2_HOME'
           }
       
  stages {
    stage('Git Checkout') {
      steps {
        echo 'This stage is to clone the repo from github'
        git branch: 'master', url: 'https://github.com/rakesh1050/banking-finance.git'
                        }
            }
    stage('Create Package') {
      steps {
        echo 'This stage will compile, test, package my application'
        sh 'mvn package'
                          }
            }
    stage('Generate Test Report') {
      steps {
        echo 'This stage generate Test report using TestNG'
        publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/banking-finance/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                          }
            }
    stage('Create Docker Image') {
      steps {
        echo 'This stage will Create a Docker image'
        sh "docker image build -t rakesh1050/banking-finance:1.0 ."
                          }
            }
    stage('Login to Dockerhub') {
      steps {
        echo 'This stage will loginto Dockerhub'
        withCredentials([usernamePassword(credentialsId: 'dockerloginnew', passwordVariable: 'dockerpass', usernameVariable: 'dockeruser')]) {
        sh 'docker login -u ${dockeruser} -p ${dockerpass}'
            }
        }
    }
      stage('Docker Push-Image') {
      steps {
        echo 'This stage will push my new image to the dockerhub'
        sh 'docker push rakesh1050/banking-finance:1.0'
          }
      }
      stage('Config & Deployment') {
            steps {
                
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS-ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    dir('terraform-files') {
                    sh 'sudo chmod 600 Jenkins.pem'
                    sh 'terraform init'
                    sh 'terraform validate'
                    sh 'terraform apply --auto-approve'
      }
     }
   }
 }
}    
}
