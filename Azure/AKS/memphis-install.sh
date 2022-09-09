az aks get-credentials --name memphis_cluster --resource-group rg1
kubectl apply -f memphis_config/svc.yaml
kubectl get svc memphis-ui -n memphis
