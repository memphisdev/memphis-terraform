.DEFAULT_GOAL := info

info:

	@echo "infra - to create a GKE cluster."
	@echo "app - to deploy Memphis into GKE Cluster"
	@echo "cluster - to deploy Memphis cluster into GKE Cluster"
	@echo "allinone - to deploy GKE cluster with Memphis"
	@echo "clusterallinone - to deploy GKE cluster with Memphis Cluster"
	@echo "destroy - to destroy Memphis and GKE Cluster"
	@echo "destroymemphis - to destroy Memphis"
	@echo "destroyinfra - to destroy Memphis GKE Cluster"

infra:

	@terraform init
	@terraform plan -out=tfplan
	@terraform apply tfplan

app:

	@echo "Deploying Memphis to GKE"
	./memphis-install.sh

cluster:

	@echo "Deploying Memphis cluster to GKE"
	./memphis-cluster-install.sh

allinone:
	@terraform init
	@terraform plan -out=tfplan
	@terraform apply tfplan
	@echo "Deploying Memphis to GKE"
	./memphis-install.sh

clusterallinone:
	@terraform init
	@terraform plan -out=tfplan
	@terraform apply tfplan
	@echo "Deploying Memphis Cluster to GKE"
	./memphis-cluster-install.sh

destroy:
	@echo "Destroy Memphis+GKE"
	./memphis-uninstall.sh
	@terraform destroy

destroymemphis:
	@echo "Destroy Memphis"
	./memphis-uninstall.sh

destroyinfra:
	@echo "Destroy GKE"
	@terraform destroy   
