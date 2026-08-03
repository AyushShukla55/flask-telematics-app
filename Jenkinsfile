pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build Docker Images') {
            steps {
                echo 'Building multi-container services with Docker Compose...'
                sh 'docker compose build'
            }
        }

        stage('Test & Healthcheck') {
            steps {
                echo 'Starting containers and running health checks...'
                sh 'docker compose up -d'
                sleep 5
                sh 'curl -f http://localhost:5001/ || exit 1'
            }
        }

        stage('Cleanup') {
            steps {
                echo 'Tearing down test containers...'
                sh 'docker compose down'
            }
        }
    }
}