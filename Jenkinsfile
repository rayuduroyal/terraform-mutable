pipeline {
  agent { label 'WORKSTATION' }

  environment {
//    ACTION = "apply"
//    ENV = "dev"
    SSH = credentials('CENTOS_SSH')
  }

  parameters {
    choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Choose Environment')
    string(name: 'ACTION', defaultValue: 'apply', description: 'Give an action to do on terraform')
  }

  //triggers { pollSCM('H/2 * * * *') }

  options {
    ansiColor('xterm')
    disableConcurrentBuilds()
  }

  stages {

    stage('VPC') {
      steps {
        sh 'echo ${SSH} >/tmp/out'

        sh '''
        cd vpc
        make ${ENV}-${ACTION}
      '''
      }
    }

    stage('DB & ALB') {
      parallel {
        stage('DB') {
//      when {
//        beforeInput true
//        branch 'production'
//      }
//      input {
//        message "Should we continue?"
//        ok "Yes, we should."
//        submitter "admin"
//      }
          steps {
            sh '''
        cd db
        make ${ENV}-${ACTION}
      '''
          }
        }

        stage('ALB') {
          steps {
            sh '''
        cd alb
        make ${ENV}-${ACTION}
      '''
          }
        }
      }}

  }
}
