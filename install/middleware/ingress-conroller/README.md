```
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

```
az acr list -g aks-rg -o table
```
<pre>
NAME      RESOURCE GROUP    LOCATION     SKU    LOGIN SERVER         CREATION DATE         ADMIN ENABLED
--------  ----------------  -----------  -----  -------------------  --------------------  ---------------
acr17388  aks-rg            northeurope  Basic  acr17388.azurecr.io  2022-03-05T09:16:38Z  False
</pre>

```
REGISTRY_NAME=acr17388.azurecr.io
SOURCE_REGISTRY=k8s.gcr.io
CONTROLLER_IMAGE=ingress-nginx/controller
CONTROLLER_TAG=v1.1.2
PATCH_IMAGE=ingress-nginx/kube-webhook-certgen
PATCH_TAG=v1.1.1
DEFAULTBACKEND_IMAGE=defaultbackend-amd64
DEFAULTBACKEND_TAG=1.5

az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$CONTROLLER_IMAGE:$CONTROLLER_TAG --image $CONTROLLER_IMAGE:$CONTROLLER_TAG
az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$PATCH_IMAGE:$PATCH_TAG --image $PATCH_IMAGE:$PATCH_TAG
az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$DEFAULTBACKEND_IMAGE:$DEFAULTBACKEND_TAG --image $DEFAULTBACKEND_IMAGE:$DEFAULTBACKEND_TAG
```


```
kubectl create ns ingress-controller
```
<pre>
namespace/ingress-controller created
</pre>

```
helm search repo  ingress
```
<pre>
NAME                            CHART VERSION   APP VERSION     DESCRIPTION
ingress-nginx/ingress-nginx     4.0.18          1.1.2           Ingress controller for Kubernetes using NGINX a...
</pre>

```
# Set variable for ACR location to use for pulling images
ACR_URL=acr17388.azurecr.io
CONTROLLER_IMAGE=ingress-nginx/controller
CONTROLLER_TAG=v1.1.2
PATCH_IMAGE=ingress-nginx/kube-webhook-certgen
PATCH_TAG=v1.1.1
DEFAULTBACKEND_IMAGE=defaultbackend-amd64
DEFAULTBACKEND_TAG=1.5
# Use Helm to deploy an NGINX ingress controller
helm upgrade nginx-ingress ingress-nginx/ingress-nginx \
    --version 4.0.18 \
    --namespace ingress-controller --create-namespace \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."kubernetes\.io/os"=linux \
    --set controller.image.registry=$ACR_URL \
    --set controller.image.image=$CONTROLLER_IMAGE \
    --set controller.image.tag=$CONTROLLER_TAG \
    --set controller.image.digest="" \
    --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.image.registry=$ACR_URL \
    --set controller.admissionWebhooks.patch.image.image=$PATCH_IMAGE \
    --set controller.admissionWebhooks.patch.image.tag=$PATCH_TAG \
    --set controller.admissionWebhooks.patch.image.digest="" \
    --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
    --set defaultBackend.image.registry=$ACR_URL \
    --set defaultBackend.image.image=$DEFAULTBACKEND_IMAGE \
    --set defaultBackend.image.tag=$DEFAULTBACKEND_TAG \
    --set defaultBackend.image.digest=""

```
TODO

code = Unknown desc = failed to pull and unpack image "acr17388.azurecr.io/ingress-nginx/kube-webhook-certgen:v1.1.1": failed to resolve reference "acr17388.azurecr.io/ingress-nginx/kube-webhook-certgen:v1.1.1": failed to authorize: failed to fetch oauth token: unexpected status: 401 Unauthorized, rpc error: code = Unknown desc = failed to pull and unpack image "acr17388.azurecr.io/ingress-nginx/kube-webhook-certgen:v1.1.1": failed to resolve reference "acr17388.azurecr.io/ingress-nginx/kube-webhook-certgen:v1.1.1": failed to authorize: failed to fetch anonymous token: unexpected status: 401 Unauthorized]



```
export LoadBalancerIP=40.127.245.113

export DnsLabel=myingress

helm upgrade nginx-ingress ingress-nginx/ingress-nginx \
  --namespace ingress-controller \
  --set controller.replicaCount=2 \
  --set controller.service.loadBalancerIP="${LoadBalancerIP}" \
  --set controller.service.annotations."service.beta.kubernetes.io/azure-dns-label-name"="${DnsLabel}"
```

```
helm list -n ingress-controller
```


```
kubectl get all -n ingress-controller
```
