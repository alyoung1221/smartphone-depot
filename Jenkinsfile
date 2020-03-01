pipeline {
    agent any
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'dev', credentialsId: 'f84109f2-8e72-4655-a187-f77ba3db3e81', url: 'https://bitbucket.org/f6consulting/smartphone-depot/src/dev/src/'
            }
        }
    stage('Sonarqube') {
        environment {
            scannerHome = tool 'sonar-scanner'
    }
        steps {
            withSonarQubeEnv('sonarqube-server') {
                sh "${scannerHome}/bin/sonar-scanner"
            }
            timeout(time: 10, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
            }
        }
    }
            }
    }
}