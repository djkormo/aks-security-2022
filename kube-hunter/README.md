The example job.yaml file defines a Job that will run kube-hunter in a pod, using default Kubernetes pod access settings. (You may wish to modify this definition, for example to run as a non-root user, or to run in a different namespace.)

Run the job with 
```
kubectl create -f ./job.yaml
```

Find the pod name with 
```
kubectl describe job kube-hunter
```
View the test results with 

```
kubectl logs <pod name>
```

https://github.com/aquasecurity/kube-hunter

