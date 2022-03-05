
### Creating AKS cluster with AAD integration

Create AKS cluster

```
bash aks-network-policy-calico-install.bash -n aks-security2021 -g aks-rg -l northeurope -o create
```


You can try script in debug mode

```
bash -x aks-network-policy-calico-install.bash -n aks-security2021 -g aks-rg -l northeurope -o create
```

Stop all VMs in AKS cluster

```
bash aks-network-policy-calico-install.bash -n aks-security2021 -g aks-rg -l northeurope -o stop
```

Start all VMs in AKS cluster

```
bash aks-network-policy-calico-install.bash -n aks-security2021 -g aks-rg -l northeurope -o start
```

Check status of all VMs in AKS cluster

```
bash aks-network-policy-calico-install.bash -n aks-security2021 -g aks-rg -l northeurope -o status
```

Delete AKS cluster

```
bash aks-network-policy-calico-install.bash -n aks-security2021 -g aks-rg -l northeurope -o delete
```


Download cli for kubernetes

```
az aks install-cli
```

Download kubernetes context file

```
az aks get-credentials --name aks-security2021  --resource-group aks-rg --overwrite
```


Trying to get information on kubernetes nodes after completing login to AAD

To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code xxxxxxxxx to authenticate.


```
kubectl get nodes  
```
<pre>
Error from server (Forbidden): nodes is forbidden: User "6dfa4fdf-09bb-4480-8b7a-d44ba0d80892" cannot list resource "nodes" in API group "" at
the cluster scope
</pre>

Permission testing

```
kubectl auth can-i create deployments --namespace default
```
<pre>
no
</pre>

```
kubectl auth can-i list nodes --namespace default
```
<pre>
Warning: resource 'nodes' is not namespace scoped
no
</pre>

```
kubectl auth can-i list secrets --namespace default
```
<pre>
no
</pre>

No permission ?


Add myself to admin group for aks cluster 

```bash
AKS_NAME=aks-security2021
USER_NAME=kormo_gos.pl#EXT#@ITSpec340.onmicrosoft.com
GROUP_NAME="${AKS_NAME}AdminGroup"
USER_ID=$(az ad user show --id $USER_NAME --query objectId --output tsv)  
az ad group member add --group "${AKS_NAME}AdminGroup" --member-id $USER_ID
```


Permission testing
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code xxxxxxx to authenticate.

```
kubectl get nodes
```
<pre>
NAME                       STATUS   ROLES   AGE   VERSION
aks-nodepool1-16333879-0   Ready    agent   22m   v1.19.1
aks-nodepool1-16333879-1   Ready    agent   21m   v1.19.1
</pre>

```
kubectl auth can-i create deployments --namespace default
```
<pre>
yes
</pre>

```
kubectl auth can-i list nodes --namespace default
```
<pre>
Warning: resource 'nodes' is not namespace scoped
yes
</pre>

```
kubectl auth can-i list secrets --namespace default
```
<pre>
yes
</pre>


Let's deploy two sample applications

```bash
kubectl create ns alpha

kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml -n alpha

kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml -n alpha

kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml -n alpha

kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml -n alpha

kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml -n alpha

kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml -n alpha

kubectl create ns beta

kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml -n beta

```
Bonus

Download context file in admin mode

```
az aks get-credentials --name aks-security2021 --resource-group aks-rg --admin
```

and check permissions 

