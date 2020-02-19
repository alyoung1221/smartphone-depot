pipeline {
    agent any
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'dev', credentialsId: 'f84109f2-8e72-4655-a187-f77ba3db3e81', url: 'https://Arian92@bitbucket.org/f6consulting/smartphone-depot.git'
            }
        }
    }
}