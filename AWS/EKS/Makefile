.DEFAULT_GOAL := info

info:

	@echo "infra - to create a EKS cluster."
	@echo "app - to deploy Memphis into EKS Cluster"
	@echo "destroy - to destroy Memphis and EKS Cluster"
	@echo "destroyapp - to destroy Memphis"
	@echo "destroyinfra - to destroy Memphis EKS Cluster"

infra:

	@terraform init
	@terraform plan
	@terraform apply

app:

	@echo "Deploying Memphis to EKS"
	./memphis-install.sh

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
