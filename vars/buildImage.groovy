def call(String image) {
    sh "docker build -t ${image} app"
}

