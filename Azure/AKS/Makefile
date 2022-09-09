.DEFAULT_GOAL := info

info:x
	@echo "infra - to create the AKS cluster."
	@echo "app - to deploy Memphis Service"
	@echo "allinone - to deploy AKS cluster with Memphis Service"
	@echo "destroy - to destroy Memphis and AKS Cluster"
	@echo "destroyapp - to destroy Memphis Service"
	@echo "destroyinfra - to destroy Memphis AKS Cluster"

infra:
	@terraform init
	@terraform apply

app:
	@echo "Deploying Memphis Service to AKS"
	./memphis-install.sh

allinone:
	@terraform init
	@terraform apply
	@echo "Deploying Memphis Service to AKS"
	./memphis-install.sh

destroy:
	@echo "Destroy Memphis+AKS"
	./memphis-uninstall.sh
	@terraform destroy
	
destroyapp:
	@echo "Destroy Memphis service"
	./memphis-uninstall.sh

destroyinfra:
	@echo "Destroy AKS"
	@terraform destroy   
