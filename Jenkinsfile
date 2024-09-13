pipeline {
	agent any
	tools {
		nodejs 'NodeJS'
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
