pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t flask-telematics-app:latest .'
            }
        }
        stage('Deploy with Compose') {
            steps {
                sh 'docker-compose down -v'
                sh 'docker-compose up -d --build'
            }
        }
    }
}
