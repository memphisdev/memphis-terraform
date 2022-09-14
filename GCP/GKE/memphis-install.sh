gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)
helm repo add memphis https://k8s.memphis.dev/charts/
helm install my-memphis memphis/memphis --create-namespace --namespace memphis
kubectl apply -f memphis/svc.yaml
until kubectl get pods --selector=app=memphis-ui -o=jsonpath="{.items[*].status.phase}" -n memphis  | grep -q "Running" ; do sleep 1; done
echo "Dashboard: http://$(kubectl get svc memphis-ui -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n memphis)"
