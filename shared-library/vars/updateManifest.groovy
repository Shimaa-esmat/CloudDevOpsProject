def call(String imageName) {
    sh "sed -i 's|image: .*|image: ${imageName}|' k8s/deployment.yaml"
}
