.DEFAULT_GOAL := info

info:

	@echo "infra - to create a EKS cluster."
	@echo "app - to deploy standalone Memphis into EKS Cluster"
	@echo "cluster - to deploy Memphis cluster into EKS Cluster"
	@echo "allinone - to deploy EKS cluster with Memphis"
	@echo "clusterallinone- to deploy EKS cluster with Memphis Cluster"
	@echo "destroy - to destroy Memphis and EKS Cluster"
	@echo "destroymemphis - to destroy Memphis"
	@echo "destroyinfra - to destroy Memphis EKS Cluster"

infra:

	@terraform init
	@terraform plan -out=tfplan
	@terraform apply tfplan

app:

	@echo "Deploying Memphis to EKS"
	./memphis-install.sh

cluster:

	@echo "Deploying Memphis cluster to EKS"
	./memphis-cluster-install.sh

allinone:
	@terraform init
	@terraform plan -out=tfplan
	@terraform apply tfplan
	@echo "Deploying Memphis to EKS"
	./memphis-install.sh

clusterallinone:
	@terraform init
	@terraform plan -out=tfplan
	@terraform apply tfplan
	@echo "Deploying Memphis Cluster to EKS"
	./memphis-cluster-install.sh

destroy:
	@echo "Destroy Memphis+EKS"
	./memphis-uninstall.sh
	@terraform destroy
	
destroymemphis:
	@echo "Destroy Memphis"
	./memphis-uninstall.sh

destroyinfra:
	@echo "Destroy EKS"
	@terraform destroy -auto-approve
