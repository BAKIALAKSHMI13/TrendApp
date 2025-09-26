pipeline {
    agent any

    tools {
        dockerTool 'docker'
    }

    stages {
        stage('Clone Code') {
            steps {
                git branch: 'main', url: 'https://github.com/BAKIALAKSHMI13/TrendApp.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("bakia/trendapp:latest")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withDockerRegistry([ credentialsId: 'dockerhub-cred', url: '' ]) {
                    script {
                        docker.image("bakia/trendapp:latest").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
            }
        }
    }
}