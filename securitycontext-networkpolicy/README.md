

wget https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml




cat kubernetes-manifests.yaml | kubectl split-yaml -t "{{.kind}}/{{.name}}.yaml" -p manifests 

