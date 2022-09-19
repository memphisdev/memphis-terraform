clusterid=$(terraform output -raw cluster_id)
echo $clusterid
aws eks update-kubeconfig --name $clusterid
helm repo add memphis https://k8s.memphis.dev/charts/
helm install my-memphis memphis/memphis --create-namespace --namespace memphis
kubectl apply -f memphis/svc.yaml
until kubectl get svc memphis-cluster-external -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}' -n memphis| grep -q ""; do sleep 1; done
echo ""
echo "---------------------------------------------------------------------------------------------------------------------------------------------"
echo ""
echo "To access Memphis using UI/CLI/SDK using service EXTERNAL-IP, run the below commands:"
echo "Dashboard: http://$(kubectl get svc memphis-cluster-external -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}' -n memphis):9000"
echo "Memphis broker: http://$(kubectl get svc memphis-cluster-external -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}' -n memphis):6666 (Client Connections)"
echo "Memphis broker: http://$(kubectl get svc memphis-cluster-external -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}' -n memphis):9000 (CLI Connections)"
