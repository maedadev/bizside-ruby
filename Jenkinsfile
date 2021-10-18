@Library('jenkins_shared_library') _

pipeline {
    agent none
    environment {
        CI = 'jenkins'
        COVERAGE = 'true'
        INTERACTIVE = 'no'
        RAILS_ENV = 'test'
        ROLE = 'test'
    }
    stages {
        stage('tests') {
            parallel {
                stage('unit') {
                    agent any
                    steps {
                        script {
                            docker.withRegistry('https://' + env.ECR_REPO, 'ecr:ap-northeast-1:ecr') {
                                def image = docker.image('bizside-centos7.6-ruby-2.5-python-3.6:latest')
                                image.pull()
                                image.inside() {
                                    sh 'sudo yum install -y sqlite-devel'
                                    sh 'bundle install -j2 --quiet --without=itamae'
                                    sh 'bundle exec rake install'
                                    dir('./bizside_test_app') {
                                      sh 'bundle install -j2'
                                    }
                                    sh 'bundle exec rake test CONFIG_FILE=bizside_test_app/config/bizside.yml'
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
