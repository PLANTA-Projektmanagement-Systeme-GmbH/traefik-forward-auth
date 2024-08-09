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
}
