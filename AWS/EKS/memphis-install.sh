clusterid=$(terraform output -raw cluster_id)
echo $clusterid
aws eks update-kubeconfig --name $clusterid
helm repo add memphis https://k8s.memphis.dev/charts/
helm install my-memphis memphis/memphis --create-namespace --namespace memphis
kubectl apply -f memphis/svc.yaml
until kubectl get pods --selector=app.kubernetes.io/name=memphis -o=jsonpath="{.items[*].status.phase}" -n memphis  | grep -q "Running" ; do sleep 1; done
echo "Dashboard: http://$(kubectl get svc memphis-cluster-external -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}' -n memphis)"
