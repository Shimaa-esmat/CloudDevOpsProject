def call(String imageName) {
    sh "docker login -u $DOCKER_USER -p $DOCKER_PASS"
    sh "docker push ${imageName}"
}
