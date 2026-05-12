pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'git@github.com:Seif-k123/nginx-log-analyzer.git'
            }
        }

        stage('Setup Permissions') {
            steps {
                sh 'chmod +x analyzer.sh'
            }
        }

        stage('Run Log Analyzer') {
            steps {
                sh './analyzer.sh sample.log'
            }
        }

        stage('Archive Reports') {
            steps {
                archiveArtifacts artifacts: 'reports/*.txt', fingerprint: true
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline executed successfully!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}
