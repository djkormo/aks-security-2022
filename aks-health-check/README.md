```
docker run -it --network host --rm ghcr.io/boxboat/aks-health-check  
```

```
# Shell in the container
```
```
az login
az account list -o table
az account set -s <subscription id>
az aks list -o table

az aks get-credentials -g aks-rg -n aks-security2022 --admin --overwrite-existing

aks-hc check all -g aks-rg -n aks-security2022 \
  -i ingress-nginx,kube-node-lease,kube-public,kube-system,tigera-operator,calico-system,gatekeeper-system -v

aks-hc check all -g aks-rg -n aks-security2022 \
  -i ingress-nginx,kube-node-lease,kube-public,kube-system,tigera-operator,calico-system,gatekeeper-system -v >> logs/aks.log

aks-hc check all -g azuresummit2k22-kp -n aks-security2022 \
  -i ingress-nginx,kube-node-lease,kube-public,kube-system,tigera-operator,calico-system,gatekeeper-system -v


bash bash/run-aks-heath-check.bash -n aks-security2022 -g aks-rg  -i "ingress-nginx,kube-node-lease,kube-public,kube-system,tigera-operator,gatekeeper-system" -l "logs/aks.log"

exit
```



kubectl create ns demo

Install demo application

kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml -n demo 


Install ingress controller


Install ISTIO

https://istio.io/latest/docs/setup/install/helm/

```
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

kubectl create namespace istio-system

helm install istio-base istio/base -n istio-system

helm install istiod istio/istiod -n istio-system --wait

```



Literature:


https://docs.microsoft.com/en-us/azure/aks/best-practices

https://github.com/boxboat/aks-health-check

https://boxboat.com/2021/08/04/aks-health-check/

https://www.youtube.com/watch?v=iQyBfon81uk


