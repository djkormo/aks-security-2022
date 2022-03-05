```
kubectl get roles --all-namespaces -o json > Roles.json

kubectl get clusterroles -o json > clusterroles.json

kubectl get rolebindings --all-namespaces -o json > rolebindings.json

kubectl get clusterrolebindings -o json > clusterrolebindings.json
```
```
python ExtensiveRoleCheck.py --clusterRole clusterroles.json  --role Roles.json --rolebindings rolebindings.json --cluseterolebindings clusterrolebindings.json
```

<pre>
[*] Started enumerating risky ClusterRoles:
[!][ClusterRole]→ aks-service Has permission to use list on any resource!
[!][ClusterRole]→ aks-service Has permission to list secrets!
[!][ClusterRole]→ aks-service Has permission to create pods!
[!][ClusterRole]→ aks-service Has permission to use pod exec!
[!][ClusterRole]→ aks-service Has permission to attach pods!
[!][ClusterRole]→ aks-service Has permission to create replicationcontrollers!
[!][ClusterRole]→ aks-service Has permission to create deployments!
[!][ClusterRole]→ aks-service Has permission to create jobs!
[!][ClusterRole]→ aks-service Has permission to create deployments!
[!][ClusterRole]→ aks-service Has permission to use list on any resource!
[!][ClusterRole]→ aks-service Has permission to use delete on any resource!
[!][ClusterRole]→ aks-service Has permission to use delete on any resource!
[!][ClusterRole]→ csi-azurefile-node-secret-role Has permission to list secrets!
[!][ClusterRole]→ gatekeeper-manager-role Has permission to use list on any resource!
[!][ClusterRole]→ gatekeeper-manager-role Has permission to use delete on any resource!
[!][ClusterRole]→ gatekeeper-manager-role Has permission to use delete on any resource!
[!][ClusterRole]→ gatekeeper-manager-role Has permission to use delete on any resource!
[!][ClusterRole]→ nginx-ingress-ingress-nginx Has permission to list secrets!
[!][ClusterRole]→ policy-agent Has permission to use delete on any resource!
[!][ClusterRole]→ tigera-operator Has permission to list secrets!
[!][ClusterRole]→ tigera-operator Has permission to create pods!
[!][ClusterRole]→ tigera-operator Has permission to create rolebindings!
[!][ClusterRole]→ tigera-operator Has permission to create deployments!
[!][ClusterRole]→ tigera-operator Has permission to use delete on any resource!
[*] Started enumerating risky Roles:
[!][Role]→ gatekeeper-manager-role Has permission to list secrets!
[!][Role]→ nginx-ingress-ingress-nginx Has permission to list secrets!
[!][Role]→ azure-policy-webhook-role Has permission to list secrets!
[!][Role]→ tunnelfront-secret Has permission to list secrets!
[*] Started enumerating risky ClusterRoleBinding:
[!][ClusterRoleBinding]→ aks-service-rolebinding is binded to the User: aks-support!
[!][ClusterRoleBinding]→ csi-azurefile-node-secret-binding is binded to csi-azurefile-node-sa ServiceAccount.
[!][ClusterRoleBinding]→ gatekeeper-manager-rolebinding is binded to gatekeeper-admin ServiceAccount.
[!][ClusterRoleBinding]→ nginx-ingress-ingress-nginx is binded to nginx-ingress-ingress-nginx ServiceAccount.
[!][ClusterRoleBinding]→ policy-agent is binded to azure-policy ServiceAccount.
[!][ClusterRoleBinding]→ tigera-operator is binded to tigera-operator ServiceAccount.
[*] Started enumerating risky RoleRoleBindings:
[!][RoleBinding]→ gatekeeper-manager-rolebinding is binded to gatekeeper-admin ServiceAccount.
[!][RoleBinding]→ nginx-ingress-ingress-nginx is binded to nginx-ingress-ingress-nginx ServiceAccount.
[!][RoleBinding]→ azure-policy-webhook-rolebinding is binded to azure-policy-webhook-account ServiceAccount.
[!][RoleBinding]→ tunnelfront is binded to tunnelfront ServiceAccount.

</pre>


Literature:

https://github.com/cyberark/kubernetes-rbac-audit

