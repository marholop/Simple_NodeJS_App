pipeline {
	agent any
	tools {
		nodejs 'NodeJS'
	}
	environment {
		SONARQUBE_URL = 'SonarQube'	
		SONAR_SCANNER_HOME = tool 'SonarQubeScanner'
		SONAR_PROJECT_KEY = 'nodejs-app'
		SONAR_TOKEN = credentials('sonar-token')
	}

	stages {
		stage('Checkout Github'){
			steps {
				git branch: 'main', credentialsId: 'github-cred', url: 'https://github.com/iQuantC/Simple_NodeJS_App.git'
			}
		}
		
		stage('Install node dependencies'){
			steps {
				sh 'npm install'
			}
		}
		stage('Tests'){
			steps {
				sh 'npm test'
			}
		}
		stage('SonarQube Analysis'){
			steps {
				withSonarQubeEnv(SONARQUBE_URL) {
					sh """
                    			${SONAR_SCANNER_HOME}/bin/sonar-scanner \
                    			-Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                    			-Dsonar.sources=. \
                    			-Dsonar.host.url=http:${SONARQUBE_URL} \
                    			-Dsonar.login=${SONAR_TOKEN}
                    			"""
				}
			}
		}	
	}
	post {
		success {
			echo 'Build completed succesfully!'
		}
		failure {
			echo 'Build failed. Check logs.'
		}
	}

}
