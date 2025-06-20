pipeline {
  agent {
    label 'linux' // or whatever your agent label is
  }

  environment {
    VERSION = "1.0.${BUILD_NUMBER}"
    APP_NAME = "SimpleIISApp"
    NEXUS_URL = "http://10.1.96.4:8098"
    NEXUS_REPO = "static-repo"
    ZIP_FILE = "${APP_NAME}-${VERSION}.zip"
    DEPLOY_SCRIPT = "C:/deployment/deploy-dotnet.ps1"
    SSH_USER = "Admin1"
    SSH_HOST = "10.1.96.4"
    SSH_CRED_ID = "windows-ssh-deploy" // SSH private key credential ID in Jenkins
  }

  stages {
    stage('Build & Publish') {
      steps {
        sh 'dotnet publish SimpleIISApp -c Release -o published'
      }
    }

    stage('Archive as ZIP') {
      steps {
        sh 'zip -r ${ZIP_FILE} published/*'
      }
    }

    stage('Upload to Nexus') {
      steps {
        sh """
          curl -u admin:admin123 \
            --upload-file ${ZIP_FILE} \
            ${NEXUS_URL}/repository/${NEXUS_REPO}/${ZIP_FILE}
        """
      }
    }

    stage('Trigger IIS Deployment') {
      steps {
        sshagent (credentials: [SSH_CRED_ID]) {
          sh """
            ssh -o StrictHostKeyChecking=no ${SSH_USER}@${SSH_HOST} \
              powershell.exe -ExecutionPolicy Bypass -File ${DEPLOY_SCRIPT} -version ${VERSION}
          """
        }
      }
    }
  }

  post {
    success {
      echo "✅ Deployment pipeline complete!"
    }
    failure {
      echo "❌ Deployment failed. Please check the logs."
    }
  }
}
