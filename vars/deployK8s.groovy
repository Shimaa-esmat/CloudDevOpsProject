def call(String namespace) {
    sh "kubectl apply -f k8s/ -n ${namespace}"
}
