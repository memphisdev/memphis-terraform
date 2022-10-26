clusterid=$(terraform output -raw cluster_id)
echo $clusterid
aws eks update-kubeconfig --name $clusterid
helm install my-memphis ../../memphis-k8s/memphis --set analytics='false',cluster.enabled="true" --create-namespace --namespace memphis
