
Get Repo Info

```
helm repo add osm https://openservicemesh.github.io/osm
helm repo update
```

```
helm show values osm/osm
```

```
helm template osm osm/osm --values values.yaml

```


Install Chart

```
helm install osm osm/osm --values values.yaml

```


Uninstall Chart

```
helm uninstall osm
```

This removes all the Kubernetes components associated with the chart and deletes the release.

Upgrading Chart

```
helm upgrade osm osm/osm  --install --values values.yaml
```
https://github.com/openservicemesh/osm/tree/release-v0.11/charts/osm