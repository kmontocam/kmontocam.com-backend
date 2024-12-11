pipeline {
    agent {
        kubernetes {
            yaml '''
                apiVersion: "v1"
                kind: "Pod"
                metadata:
                  annotations:
                    devops.kmontocam.com: "true"
                    devops.kmontocam.com/cicd: "true"
                    devops.kmontocam.com/service: jenkins
                    kmontocam.com/environment: prod
                  namespace: jenkins
                spec:
                  containers:
                  - args:
                    - "--host=tcp://127.0.0.1:2375"
                    command:
                    - "dockerd-entrypoint.sh"
                    image: "docker:27.1.1-dind"
                    imagePullPolicy: "IfNotPresent"
                    name: "docker"
                    resources:
                      limits:
                        cpu: 1
                        memory: 1500Mi
                      requests:
                        cpu: 500m
                        memory: 750Mi
                    securityContext:
                      privileged: true
                    tty: true
                    volumeMounts:
                    - mountPath: "/mnt/sqlx"
                      name: "volume-0"
                      readOnly: false
                    workingDir: "/home/jenkins/agent"
                  - args:
                    - "infinity"
                    command:
                    - "sleep"
                    image: "ghcr.io/kmontocam/rust/sqlx-cli-ssl:1.82-bookworm"
                    imagePullPolicy: "Always"
                    name: "sqlx"
                    resources:
                      limits:
                        cpu: 1
                        memory: 1500Mi
                      requests:
                        cpu: 500m
                        memory: 750Mi
                    securityContext:
                      privileged: true
                    tty: false
                    volumeMounts:
                    - mountPath: "/mnt/sqlx"
                      name: "volume-0"
                      readOnly: false
                    workingDir: "/home/jenkins/agent"
                  - name: jnlp
                    resources:
                      limits:
                        cpu: 400m
                        memory: 1024Mi
                      requests:
                        cpu: 100m
                        memory: 256Mi
                  hostNetwork: false
                  nodeSelector:
                    kubernetes.io/os: linux
                  restartPolicy: "Never"
                  volumes:
                  - emptyDir:
                      medium: ""
                    name: "volume-0"
                '''
        }
    }
    environment {
        GHCR_NAME = 'grcr.io/kmontocam/'
    }
    stages {
        stage('GET GIT TAG') {
            steps {
                script {
                    env.HEAD_GIT_TAG = sh(script: 'git tag --points-at HEAD 2>/dev/null || echo ""', returnStdout: true).trim()
                    if (env.HEAD_GIT_TAG == '') {
                        error('No tag found for the HEAD of the Git repo. Build must include a tag.')
                    }
                }
            }
        }
        stage('SQLX COMPILE') {
            steps {
                withCredentials([ string(credentialsId: 'b8dc1ddf-5c3c-4e56-94d4-5c234db34e09', variable: 'DATABASE_URL') ]) {
                    container('sqlx') {
                        sh '''
                            export DATABASE_URL=${DATABASE_URL}
                            cargo sqlx migrate run
                            cargo sqlx prepare
                            cp -R .sqlx /mnt/sqlx
                            '''
                    }
                }
            }
        }
        stage('DOCKER BUILD') {
            steps {
                container('docker') {
                    withCredentials([ string(credentialsId: 'd2ebee8c-fe21-4ca9-a935-a2b70c336b5b', variable: 'GHCR_TOKEN') ]) {
                        script {
                            def dockerTag = ''
                            switch (env.BRANCH_NAME) {
                                case 'develop':
                                    dockerTag = 'latest'
                                    break
                                case 'main':
                                    dockerTag = 'stable'
                                    break
                                default:
                                    error("Unknown branch: ${env.BRANCH_NAME}")
                            }
                            env.DOCKER_TAG = dockerTag
                            def pipelineName = env.JOB_NAME.tokenize('/')[1] // use repo name as image name in container registry
                            env.DOCKER_IMAGE = env.GHCR_NAME + pipelineName
                            sh 'echo ${GHCR_TOKEN} | docker login ghcr.io -u kmontocam --password-stdin'
                            if (env.BRANCH_NAME == 'main') { // pull image to mantain same sha256
                                sh 'docker pull ${DOCKER_IMAGE}:${HEAD_GIT_TAG}'
                            } else {
                                sh '''
                                    cp -R /mnt/sqlx/.sqlx ./
                                    docker build -t ${DOCKER_IMAGE}:${HEAD_GIT_TAG} .
                                    '''
                            }
                            sh 'docker tag ${DOCKER_IMAGE}:${HEAD_GIT_TAG} ${DOCKER_IMAGE}:${DOCKER_TAG}'
                        }
                    }
                }
            }
        }
        stage('DOCKER PUSH TO GHCR') {
            steps {
                container('docker') {
                    withCredentials([ string(credentialsId: 'd2ebee8c-fe21-4ca9-a935-a2b70c336b5b', variable: 'GHCR_TOKEN') ]) {
                        script {
                            sh '''
                                echo ${GHCR_TOKEN} | docker login ghcr.io -u kmontocam --pasword-stdin
                                docker push ${DOCKER_IMAGE}:${HEAD_GIT_TAG}
                                docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                                '''
                        }
                    }
                }
            }
        }
    }
}
