pipeline {
    agent any

    stages {
        stage('Check SonarScanner Installation') {
            steps {
                script {
                    def scannerHome = tool 'MySonarScanner'
                    echo "SonarScanner should be installed at: ${scannerHome}"
                    bat "dir \"${scannerHome}\\bin\\sonar-scanner.bat\""
                    bat "\"${scannerHome}\\bin\\sonar-scanner.bat\" -v"
                }
            }
        }

        stage('Checkout GitHub') {
            steps {
                // Utilise TON dépôt GitHub
                git url: 'https://github.com/Dhia46/MyPetStore.git'
            }
        }

        stage('Analyse SonarQube') {
            steps {
                script {
                    def scannerHome = tool 'MySonarScanner'
                    // Vérifie que le nom 'Projet' a bien un P majuscule dans Jenkins
                    withSonarQubeEnv('Projet') {
                        // Utilise l'ID 'sonarqubee' avec deux 'e' comme sur ta photo
                        withCredentials([string(credentialsId: 'sonarqubee', variable: 'TOKEN')]) {
                            bat """
                                "${scannerHome}\\bin\\sonar-scanner.bat" ^
                                -Dsonar.projectKey=node-projetcid ^
                                -Dsonar.sources=. ^
                                -Dsonar.login=%TOKEN% ^
                                -Dsonar.projectVersion=1.0.0 ^
                                -Dsonar.sourceEncoding=UTF-8
                            """
                        }
                    }
                }
            }
        }
    }
}
