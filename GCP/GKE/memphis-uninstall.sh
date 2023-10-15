helm uninstall my-memphis --namespace memphis
kubectl delete -f memphis/svc.yaml
kubectl delete ns memphis
