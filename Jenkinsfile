pipeline {
	agent any
	tools {
		nodejs 'NodeJS'
	}
	environment {
		SONARQUBE_SERVER = 'SonarQube'
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
			environment {
				SCANNER_HOME = tool 'SonarQube'
			}
			steps {
				withSonarQubeEnv(credentialsId: 'sonar-token') {
    					sh '${SCANNER_HOME}/bin/sonar-scanner'
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
