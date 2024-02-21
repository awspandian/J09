pipeline {
    agent any

    stages {
        stage('SCM') {
            steps {
                git branch: 'war', url: 'https://github.com/awspandian/J09.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean'
                sh 'mvn install'
                
            }
        }
         stage('Build Docker Image') {
            steps {
                script {
                    app = docker.build("dockerpandian/f19")
                    app.inside {
                        sh 'echo $(curl localhost:8080)'
                    }
                }
            }
        }
        stage('Push Docker Image') {

            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('DeployToProduction') {

            steps {
                input 'Deploy to Production?'
                milestone(1)
                withCredentials([usernamePassword(credentialsId: 'dd21', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker pull dockerpandian/f19:${env.BUILD_NUMBER}\""
                        try {
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker stop febkaizen\""
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker rm febkaizen\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker run --restart always --name febkaizen -p 8080:8080 -d dockerpandian/f19:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }
    }
}
