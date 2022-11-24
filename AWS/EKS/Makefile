.DEFAULT_GOAL := info

info:

	@echo "infra - to create a EKS cluster."
	@echo "app - to deploy Memphis into EKS Cluster"
	@echo "allinone - to deploy Eks cluster with Memphis"
	@echo "destroy - to destroy Memphis and EKS Cluster"
	@echo "destroyapp - to destroy Memphis"
	@echo "destroyinfra - to destroy Memphis EKS Cluster"

infra:

	@terraform init
	@terraform plan -out=tfplan
	@terraform apply tfplan

app:

	@echo "Deploying Memphis to EKS"
	./memphis-install.sh

clusterapp:

	@echo "Deploying Memphis to EKS"
	./memphis-cluster-install.sh

allinone:
	@terraform init
	@terraform plan -out=tfplan
	@terraform apply tfplan
	@echo "Deploying Memphis to EKS"
	./memphis-install.sh

cluster:
	@terraform init
	@terraform plan -out=tfplan
	@terraform apply tfplan
	@echo "Deploying Memphis Cluster to EKS"
	./memphis-cluster-install.sh

destroy:
	@echo "Destroy Memphis+EKS"
	./memphis-uninstall.sh
	@terraform destroy
	
destroyapp:
	@echo "Destroy Memphis"
	./memphis-uninstall.sh

destroyinfra:
	@echo "Destroy EKS"
	@terraform destroy   
