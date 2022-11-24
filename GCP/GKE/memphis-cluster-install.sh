gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)
helm repo add memphis https://k8s.memphis.dev/charts/
helm install my-memphis memphis/memphis --set cluster.enabled="true" --create-namespace --namespace memphis --wait
kubectl apply -f memphis/svc.yaml
until kubectl get svc memphis-cluster-external -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n memphis| grep -q ""; do sleep 1; done
echo ""
echo "---------------------------------------------------------------------------------------------------------------------------------------------"
echo ""
echo "To access Memphis using UI/CLI/SDK with service EXTERNAL-IP, use the following URLs:"
echo "Dashboard: http://$(kubectl get svc memphis-cluster-external -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n memphis):9000"
echo "Memphis broker: http://$(kubectl get svc memphis-cluster-external -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n memphis):6666 (Client Connections)"
echo "Memphis broker: http://$(kubectl get svc memphis-cluster-external -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n memphis):9000 (CLI Connections)"
