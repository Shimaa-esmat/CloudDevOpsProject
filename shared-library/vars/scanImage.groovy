def call(String imageName) {
    sh "trivy image ${imageName}"
}
