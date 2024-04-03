def IMAGE
pipeline {
	agent {
    label 'dockerbuild'
	}
	options {
    disableConcurrentBuilds()
  }
  triggers {
    pollSCM 'H/15 * * * *'
  }
  environment {
    DOCKER_REGISTRY = "registry.planta.services"
    PROJECT = "atruvia"
    CHART_BASE = "oci://${DOCKER_REGISTRY}/${PROJECT}"
    REGISTRY_CRED = credentials('42421188-1fe8-4ada-b137-d975c92aa9d8')
  }
  stages {
    stage('Build') {
      steps {
        dir('helm') {
          script {
            docker.withRegistry("https://${DOCKER_REGISTRY}", '42421188-1fe8-4ada-b137-d975c92aa9d8'){
              def helm = docker.image("${DOCKER_REGISTRY}/tools/helm:latest")
              helm.inside(){
                sh '''
                  helm package oidc
                  helm push oidc-*.tgz "${CHART_BASE}"
                '''
              }
            }
          }
        }
      }
    }
	}
	post {
		success {
			office365ConnectorSend color: '#00ff00', message: "Latest Status of Build ${BUILD_DISPLAY_NAME}", status: "${currentBuild.result}", webhookUrl: 'https://plantagmbh.webhook.office.com/webhookb2/d93979e6-5d52-42f8-9169-ffb577f8169e@c0e03c1e-40ed-43d8-b600-e22d90bb07de/JenkinsCI/54ead5ec5a3c4a0480c7bbb47ee78cf1/26180525-e794-4212-a877-45a35f3fd201'
		}
		failure {
			office365ConnectorSend color: '#ff0000', message: "Latest Status of Build ${BUILD_DISPLAY_NAME}", status: "${currentBuild.result}", webhookUrl: 'https://plantagmbh.webhook.office.com/webhookb2/d93979e6-5d52-42f8-9169-ffb577f8169e@c0e03c1e-40ed-43d8-b600-e22d90bb07de/JenkinsCI/54ead5ec5a3c4a0480c7bbb47ee78cf1/26180525-e794-4212-a877-45a35f3fd201'
			office365ConnectorSend color: '#ff0000', message: "Latest Status of Build ${BUILD_DISPLAY_NAME}", status: "${currentBuild.result}", webhookUrl: 'https://plantagmbh.webhook.office.com/webhookb2/d93979e6-5d52-42f8-9169-ffb577f8169e@c0e03c1e-40ed-43d8-b600-e22d90bb07de/JenkinsCI/6c2fba73b0de45d5831f73db061b558a/26180525-e794-4212-a877-45a35f3fd201'
		}
		unstable {
			office365ConnectorSend color: '#fffd00', message: "Latest Status of Build ${BUILD_DISPLAY_NAME}", status: "${currentBuild.result}", webhookUrl: 'https://plantagmbh.webhook.office.com/webhookb2/d93979e6-5d52-42f8-9169-ffb577f8169e@c0e03c1e-40ed-43d8-b600-e22d90bb07de/JenkinsCI/54ead5ec5a3c4a0480c7bbb47ee78cf1/26180525-e794-4212-a877-45a35f3fd201'
			office365ConnectorSend color: '#fffd00', message: "Latest Status of Build ${BUILD_DISPLAY_NAME}", status: "${currentBuild.result}", webhookUrl: 'https://plantagmbh.webhook.office.com/webhookb2/d93979e6-5d52-42f8-9169-ffb577f8169e@c0e03c1e-40ed-43d8-b600-e22d90bb07de/JenkinsCI/6c2fba73b0de45d5831f73db061b558a/26180525-e794-4212-a877-45a35f3fd201'
		}
	  cleanup {
			sh 'docker system prune -af --volumes'
	  }
	}
}
