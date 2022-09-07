.DEFAULT_GOAL := info

info:

	@echo "infra - to create a EKS cluster."
	@echo "app - to deploy Memphis into EKS Cluster"
	@echo "destroyapp - to destroy Memphis"
	@echo "destroyinfra - to destroy Memphis EKS Cluster"

infra:

	@terraform init
	@terraform plan
	@terraform apply

app:

	@echo "Deploying Memphis to EKS"
	./memphis-install.sh

destroyapp:
	@echo "Deploying Memphis"
	./memphis-uninstall.sh
	@terraform destroy
destroyinfra:
	@echo "Deploying EKS"
	@terraform destroy   