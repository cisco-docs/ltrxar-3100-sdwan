pipeline {
    agent {
        docker {
            image 'danischm/nac:0.1.6'
            label 'digidev'
            args '-u root'
        }
    }

    triggers {
        cron(env.BRANCH_NAME == 'master' ? '0 4 * * *' : '')
    }

    environment {
        DD_GITHUB_TOKEN = credentials('DD_GITHUB_TOKEN')
        DD_INTERNAL_GITHUB_TOKEN = credentials('DD_INTERNAL_GITHUB_TOKEN')
        SDWAN_USERNAME = credentials('SDWAN_USERNAME')
        SDWAN_PASSWORD = credentials('SDWAN_PASSWORD')
        WEBEX_TOKEN = credentials('WEBEX_TOKEN')
        WEBEX_ROOM_ID = 'Y2lzY29zcGFyazovL3VzL1JPT00vNTFmMGNmODAtYjI0My0xMWU5LTljZjUtNWY0NGQ2ZTlmYWY0'
        GIT_COMMIT_MESSAGE = "${sh(returnStdout: true, script: 'git config --global --add safe.directory "*" && git log -1 --pretty=%B ${GIT_COMMIT}').trim()}"
        GIT_COMMIT_AUTHOR = "${sh(returnStdout: true, script: 'git show -s --pretty=%an').trim()}"
        GIT_EVENT = "${(env.CHANGE_ID != null) ? 'Pull Request' : 'Push'}"
    }

    options {
        disableConcurrentBuilds()
        newContainerPerStage()
        timeout(time: 1, unit: 'HOURS')
    }

    stages {
        stage('Lint') {
            steps {
                sh 'yamllint -s .'
                sh 'pytest -m validate'
            }
        }
        stage('Publish Documentation') {
            when {
                branch 'master'
            }
            steps {
                build job: '/netascode/netascode/master', wait: false
            }
        }
        stage('Prepare') {
            steps {
                sh "pip install cisco-sdwan"
                lock(resource: 'nac-ci-sdwan1') {
                    sh 'python3 scripts/sdwan_lab_cleanup.py https://10.50.202.6'
                }
                lock(resource: 'nac-ci-sdwan2') {
                    sh 'python3 scripts/sdwan_lab_cleanup.py https://10.50.202.8'
                }
            }
        }
        stage('Test') {
            parallel {
                stage('Test SDWAN 20.12 Terraform') {
                    steps {
                        lock(resource: 'nac-ci-sdwan1') {
                            sh 'pytest -m sdwan_2012'
                        }
                    }
                    post {
                        always {
                            junit 'sdwan_tf_20.12_xunit.xml'
                            archiveArtifacts 'sdwan_tf_20.12_*.html, sdwan_tf_20.12_*.xml'
                        }
                    }
                }
                stage('Test SDWAN 20.15 Terraform') {
                    steps {
                        lock(resource: 'nac-ci-sdwan2') {
                            sh 'pytest -m sdwan_2015'
                        }
                    }
                    post {
                        always {
                            junit 'sdwan_tf_20.15_xunit.xml'
                            archiveArtifacts 'sdwan_tf_20.15_*.html, sdwan_tf_20.15_*.xml'
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                if (env.TAG_NAME) {
                    sh 'cd scripts && python3 update_repos.py --release'
                } else if (env.BRANCH_NAME == "master") {
                    sh 'cd scripts && python3 update_repos.py'
                }
            }
            sh "BUILD_STATUS=${currentBuild.currentResult} python .ci/webex-notification-jenkins.py"
            cleanWs()
        }
    }
}
