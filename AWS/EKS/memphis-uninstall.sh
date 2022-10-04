environment=$1
namespace=memphis$environment
helm uninstall my-memphis --namespace $namespace
##kubectl delete -f memphis/svc.yaml
helm uninstall my-memphis-lb --namespace $namespace
