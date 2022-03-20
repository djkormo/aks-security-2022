
https://regex101.com/

Allowed repos

^(docker\.io)|^(gcr\.io)\/.+$


```
kubectl get constrainttemplates 
```
<pre>
NAME                             AGE
k8sazureblockdefault             5m7s
k8sazurecontainerallowedimages   5m7s
</pre>
```
kubectl get constraints
```
<pre>
NAME                                                                                                                 AGE
k8sazurecontainerallowedimages.constraints.gatekeeper.sh/azurepolicy-container-allowed-images-20e486f830023a97cf11   4m58s

NAME                                                                                                      AGE
k8sazureblockdefault.constraints.gatekeeper.sh/azurepolicy-block-default-namespace-1cfb5fb78e0737166fc9   4m58s
</pre>

```
kubectl run nginx --image=nginx -n default     
```
<pre>

Error from server ([azurepolicy-block-default-namespace-1cfb5fb78e0737166fc9] Usage of the default namespace is not allowed, name: nginx, kind: Pod): admission webhook "validation.gatekeeper.sh" denied the request: [azurepolicy-block-default-namespace-1cfb5fb78e0737166fc9] Usage of the default namespace is not allowed, name: nginx, kind: Pod
</pre>
```
kubectl get constrainttemplates k8sazurecontainerallowedimages
```
<pre>
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  annotations:
    azure-policy-definition-id-1: /providers/Microsoft.Authorization/policyDefinitions/febd0533-8e55-448f-b837-bd0e06f16469
    constraint-template: https://store.policy.core.windows.net/kubernetes/container-allowed-images/v2/template.yaml
    constraint-template-installed-by: azure-policy-addon
  creationTimestamp: "2022-03-19T08:58:08Z"
  generation: 1
  labels:
    managed-by: azure-policy-addon
  name: k8sazurecontainerallowedimages
  resourceVersion: "793055"
  uid: bbc43261-daeb-4d48-9f8a-bf25f9528d0c
spec:
  crd:
    spec:
      names:
        kind: K8sAzureContainerAllowedImages
      validation:
        legacySchema: true
        openAPIV3Schema:
          properties:
            excludedContainers:
              items:
                type: string
              type: array
            imageRegex:
              type: string
  targets:
  - rego: |
      package k8sazurecontainerallowedimages

      violation[{"msg": msg}] {
        container := input_containers[_]
        not input_container_excluded(container.name)
        not re_match(input.parameters.imageRegex, container.image)
        msg := sprintf("Container image %v for container %v has not been allowed.", [container.image, container.name])
      }

      input_containers[c] {
          c := input.review.object.spec.containers[_]
      }
      input_containers[c] {
          c := input.review.object.spec.initContainers[_]
      }
      input_container_excluded(field) {
          field == input.parameters.excludedContainers[_]
      }
    target: admission.k8s.gatekeeper.sh
status:
  byPod:
  - id: gatekeeper-audit-5c96c9b6d6-nsm4d
    observedGeneration: 1
    operations:
    - audit
    - status
    templateUID: bbc43261-daeb-4d48-9f8a-bf25f9528d0c
  - id: gatekeeper-controller-d8447dbbf-jhqvg
    observedGeneration: 1
    operations:
    - webhook
    templateUID: bbc43261-daeb-4d48-9f8a-bf25f9528d0c
  - id: gatekeeper-controller-d8447dbbf-rqs76
    observedGeneration: 1
    operations:
    - webhook
    templateUID: bbc43261-daeb-4d48-9f8a-bf25f9528d0c
  created: true
</pre>

```
kubectl describe k8sazurecontainerallowedimages.constraints.gatekeeper.sh/azurepolicy-container-allowed-images-20e486f830023a97cf11

```

<pre>

Name:         azurepolicy-container-allowed-images-20e486f830023a97cf11
Namespace:    
Labels:       managed-by=azure-policy-addon
Annotations:  azure-policy-assignment-id:
                /subscriptions/95975e47-f719-45de-9813-fea7d69635c0/resourcegroups/aks-rg/providers/Microsoft.Authorization/policyAssignments/cbaca39faa5c...
              azure-policy-definition-id: /providers/Microsoft.Authorization/policyDefinitions/febd0533-8e55-448f-b837-bd0e06f16469     
              azure-policy-definition-reference-id:
              azure-policy-setdefinition-id:
              constraint-installed-by: azure-policy-addon
              constraint-url: https://store.policy.core.windows.net/kubernetes/container-allowed-images/v2/constraint.yaml
API Version:  constraints.gatekeeper.sh/v1beta1
Kind:         K8sAzureContainerAllowedImages
Metadata:
  Creation Timestamp:  2022-03-19T08:58:49Z
  Generation:          1
  Managed Fields:
    API Version:  constraints.gatekeeper.sh/v1beta1
    Fields Type:  FieldsV1
    fieldsV1:
      f:metadata:
        f:annotations:
          .:
          f:azure-policy-assignment-id:
          f:azure-policy-definition-id:
          f:azure-policy-definition-reference-id:
          f:azure-policy-setdefinition-id:
          f:constraint-installed-by:
          f:constraint-url:
        f:labels:
          .:
          f:managed-by:
      f:spec:
        .:
        f:enforcementAction:
        f:match:
          .:
          f:excludedNamespaces:
          f:kinds:
        f:parameters:
          .:
          f:excludedContainers:
          f:imageRegex:
    Manager:      azurepolicyaddon
    Operation:    Update
    Time:         2022-03-19T08:58:49Z
    API Version:  constraints.gatekeeper.sh/v1beta1
    Fields Type:  FieldsV1
    fieldsV1:
      f:status:
    Manager:         gatekeeper
    Operation:       Update
    Subresource:     status
    Time:            2022-03-19T08:58:49Z
  Resource Version:  793516
  UID:               c64694d8-589c-4611-aabc-af4189eabfd3
Spec:
  Enforcement Action:  dryrun
  Match:
    Excluded Namespaces:
      kube-system
      gatekeeper-system
      azure-arc
    Kinds:
      API Groups:

      Kinds:
        Pod
  Parameters:
    Excluded Containers:
    Image Regex:  ^([^\/]+\.docker\.io|registry\.io)\/.+$
Status:
  Audit Timestamp:  2022-03-19T08:59:43Z
  By Pod:
    Constraint UID:       c64694d8-589c-4611-aabc-af4189eabfd3
    Enforced:             true
    Id:                   gatekeeper-audit-5c96c9b6d6-nsm4d
    Observed Generation:  1
    Operations:
      audit
      status
    Constraint UID:       c64694d8-589c-4611-aabc-af4189eabfd3
    Enforced:             true
    Id:                   gatekeeper-controller-d8447dbbf-jhqvg
    Observed Generation:  1
    Operations:
      webhook
    Constraint UID:       c64694d8-589c-4611-aabc-af4189eabfd3
    Enforced:             true
    Id:                   gatekeeper-controller-d8447dbbf-rqs76
    Observed Generation:  1
    Operations:
      webhook
  Total Violations:  12
  Violations:
    Enforcement Action:  dryrun
    Kind:                Pod
    Message:             Container image gcr.io/google-samples/microservices-demo/currencyservice:v0.1.4 for container server has not been allowed.
    Name:                currencyservice-66875bb748-f6kvf
    Namespace:           demo
    Enforcement Action:  dryrun
    Kind:                Pod
    Message:             Container image gcr.io/google-samples/microservices-demo/emailservice:v0.1.4 for container server has not been 
allowed.
    Name:                emailservice-cdb74dc86-kzn6x
    Namespace:           demo
    Enforcement Action:  dryrun
    Kind:                Pod
    Message:             Container image gcr.io/google-samples/microservices-demo/checkoutservice:v0.1.4 for container server has not been allowed.
    Name:                checkoutservice-7d4854d84d-jpqnl
    Namespace:           demo
    Enforcement Action:  dryrun
    Kind:                Pod
    Message:             Container image gcr.io/google-samples/microservices-demo/productcatalogservice:v0.1.4 for container server has 
not been allowed.
    Name:                productcatalogservice-78c7f4d74-6tk4g
    Namespace:           demo
    Enforcement Action:  dryrun
    Kind:                Pod
    Message:             Container image gcr.io/google-samples/microservices-demo/loadgenerator:v0.1.4 for container main has not been allowed.
    Name:                loadgenerator-7947764c98-67d8g
    Namespace:           demo
    Enforcement Action:  dryrun
    Kind:                Pod
    Message:             Container image gcr.io/google-samples/microservices-demo/shippingservice:v0.1.4 for container server has not been allowed.
    Name:                shippingservice-64587c864b-r27xg
    Namespace:           demo
    Enforcement Action:  dryrun
    Kind:                Pod
    Message:             Container image redis:alpine for container redis has not been allowed.
    Name:                redis-cart-d65547c8f-rn8k8
    Namespace:           demo
    Enforcement Action:  dryrun
    Kind:                Pod
    Message:             Container image gcr.io/google-samples/microservices-demo/paymentservice:v0.1.4 for container server has not been allowed.
    Name:                paymentservice-56f598cc65-w9lfz
    Namespace:           demo
    Enforcement Action:  dryrun
    Kind:                Pod
    Message:             Container image gcr.io/google-samples/microservices-demo/recommendationservice:v0.1.4 for container server has 
not been allowed.
    Name:                recommendationservice-8656895f68-z5nkm
    Namespace:           demo
    Enforcement Action:  dryrun
    Kind:                Pod
    Message:             Container image gcr.io/google-samples/microservices-demo/cartservice:v0.1.4 for container server has not been allowed.
    Name:                cartservice-5db74d749f-t4q54
    Namespace:           demo
    Enforcement Action:  dryrun
    Kind:                Pod
    Message:             Container image rookout/microservices-demo-adservice:1.0.130 for container server has not been allowed.        
    Name:                adservice-86b6d8d64c-2bkfv
    Namespace:           demo
    Enforcement Action:  dryrun
    Kind:                Pod
    Message:             Container image gcr.io/google-samples/microservices-demo/frontend:v0.1.4 for container server has not been allowed.
    Name:                frontend-6dcbf455db-dgbck
    Namespace:           demo
Events:                  <none>
</pre>

