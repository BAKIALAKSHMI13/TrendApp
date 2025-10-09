pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "bakialakshmi/trend-app:latest"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
        AWS_DEFAULT_REGION = "ap-south-1"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/BAKIALAKSHMI13/TrendApp.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                        echo $PASS | docker login -u $USER --password-stdin
                        docker build -t $DOCKER_IMAGE .
                    '''
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                        echo $PASS | docker login -u $USER --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                  withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS']]) {
                  sh '''
                    # Example deployment steps
                    aws eks update-kubeconfig --region ap-south-1 --name project2
                    chown -R jenkins:jenkins /var/lib/jenkins/.kube
                    kubectl apply -f k8s/deployment.yaml --validate=false
                    kubectl apply -f k8s/service.yaml --validate=false
                '''
                  }
                }
            }
        }
    }
}