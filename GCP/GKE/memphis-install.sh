gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)
helm repo add memphis https://k8s.memphis.dev/charts/
helm install my-memphis memphis/memphis --create-namespace --namespace memphis
kubectl apply -f memphis/svc.yaml
until kubectl get svc memphis-cluster-external -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n memphis| grep -q ""; do sleep 1; done
echo ""
echo "---------------------------------------------------------------------------------------------------------------------------------------------"
echo "To access Memphis using UI/CLI/SDK using service EXTERNAL-IP, run the below commands:"
echo "Dashboard: http://$(kubectl get svc memphis-cluster-external -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n memphis):9000"
echo "Memphis broker: http://$(kubectl get svc memphis-cluster-external -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n memphis):6666 (Client Connections)"
echo "Memphis broker: http://$(kubectl get svc memphis-cluster-external -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n memphis):9000 (CLI Connections)"
