.DEFAULT_GOAL := info

info:

	@echo "infra - to create a GKE cluster."
	@echo "app - to deploy Memphis into GKE Cluster"
	@echo "destroy - to destroy Memphis and GKE Cluster"
	@echo "destroyapp - to destroy Memphis"
	@echo "destroyinfra - to destroy Memphis GKE Cluster"

infra:

	@terraform init
	@terraform plan
	@terraform apply

app:

	@echo "Deploying Memphis to GKE"
	./memphis-install.sh

destroy:
	@echo "Destroy Memphis+GKE"
	./memphis-uninstall.sh
	@terraform destroy

destroyapp:
	@echo "Destroy Memphis"
	./memphis-uninstall.sh

destroyinfra:
	@echo "Destroy GKE"
	@terraform destroy   
