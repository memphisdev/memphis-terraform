environment=$1
echo $(pwd)
if [ "$environment" = "basic" ]; then
namespace=memphis
else
namespace=memphis$environment
fi
clusterid=$(terraform output -raw cluster_id)
echo $clusterid
certificate_arn=$(terraform output -raw certificate_arn)
echo $certificate_arn
aws eks update-kubeconfig --name $clusterid
helm repo add memphis https://k8s.memphis.dev/charts/
helm upgrade --install my-memphis memphis/memphis --create-namespace --namespace $namespace
##kubectl apply -f memphis/svc.yaml
if [ "$environment" = "basic" ]; then
helm upgrade --install --namespace $namespace -f helm/values.yaml my-memphis-lb ./helm
else
helm upgrade --install --namespace $namespace -f helm/values.yaml -f ../../values.aws$environment.yaml --set certificatearn=$certificate_arn my-memphis-lb ./helm
fi
##until kubectl get pods --selector=app=memphis-ui -o=jsonpath="{.items[*].status.phase}" -n $namespace  | grep -q "Running" ; do sleep 1; done
##echo "Dashboard: http://$(kubectl get svc memphis-ui -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}' -n $namespace)"
