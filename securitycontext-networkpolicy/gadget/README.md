```
kubectl krew install gadget
```

```
kubectl gadget deploy > deploy-gadget.yaml
```
```
kubectl apply -f deploy-gadget.yaml
```
```
kubectl gadget deploy | kubectl apply -f 
```



<pre>
customresourcedefinition.apiextensions.k8s.io/traces.gadget.kinvolk.io created
namespace/gadget created
serviceaccount/gadget created
clusterrolebinding.rbac.authorization.k8s.io/gadget created
daemonset.apps/gadget created
</pre>

```
kubectl gadget network-policy monitor --namespaces demo --output ./demo-networktrace.log
```

```
kubectl gadget network-policy report --input ./demo-networktrace.log > network-policy-demo.yaml
```

Add deny-all network policy

```
cat network-policy-demo.yaml  | kubectl split-yaml -t "{{.kind}}/{{.name}}.yaml" -p manifests
``` 

kubectl apply -f generic-networkpolicies/default-deny-ingress.yaml -n demo 
kubectl apply -f generic-networkpolicies/default-deny-egress.yaml -n demo 
kubectl apply -f generic-networkpolicies/allow-dns-access.yaml -n demo 



```
kubectl apply -R -f manifests -n demo 
```

```
kubectl get netpol -n demo
```
<pre>
NAME                            POD-SELECTOR                AGE
cartservice-network             app=cartservice             40s
checkoutservice-network         app=checkoutservice         40s
currencyservice-network         app=currencyservice         39s
emailservice-network            app=emailservice            39s
frontend-network                app=frontend                39s
paymentservice-network          app=paymentservice          39s
productcatalogservice-network   app=productcatalogservice   39s
redis-cart-network              app=redis-cart              39s
shippingservice-network         app=shippingservice         39s
</pre>

```
kubectl gadget undeploy | kubectl apply -f 
```

Try to connect to

```
kubectl get svc/frontend-external -n demo
```
<pre>

NAME                TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)        AGE
frontend-external   LoadBalancer   10.0.204.199   20.223.105.107   80:31689/TCP   81m
</pre>

Oops ?


rpc error: code = Internal desc = cart failure: failed to get user cart during checkout: rpc error: code = Unavailable desc = connection error: desc = "transport: Error while dialing dial tcp: i/o timeout"
failed to complete the order




<pre>
Przekroczono limit czasu połączenia

Serwer 20.223.105.107 zbyt długo nie odpowiada.

    Witryna może być tymczasowo niedostępna lub przeciążona. Spróbuj ponownie za pewien czas.
    Jeśli nie możesz otworzyć żadnej strony, sprawdź swoje połączenie sieciowe.
    Jeśli ten komputer jest chroniony przez zaporę sieciową lub serwer proxy, należy sprawdzić, czy Firefox jest uprawniony do łączenia się z Internetem.
</pre>


Only traffic inside namespace **demo** was under investigation

```
kubectl apply -f generic-networkpolicies/allow-all-ingress.yaml -n demo
```
<pre>
networkpolicy.networking.k8s.io/allow-all-ingress created
</pre>



https://artturik.github.io/network-policy-viewer/

https://github.com/kinvolk/cloud-native-bpf-workshop

