clusterid=$(terraform output -raw cluster_id)
echo $clusterid
aws eks update-kubeconfig --name $clusterid
helm repo add memphis https://k8s.memphis.dev/charts/
helm install my-memphis memphis/memphis --create-namespace --namespace memphis
kubectl apply -f memphis/svc.yaml
kubectl get svc memphis-ui -n memphis
