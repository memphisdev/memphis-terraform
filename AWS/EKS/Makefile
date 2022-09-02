.DEFAULT_GOAL := info
info:
	@echo "infra - to create a EKS cluster."
	@echo "app - to deploy Memphis into EKS Cluster"
	@echo "destroy - to destroy Memphis along with EKS Cluster"
infra:
	@terraform init
	@terraform plan
	@terraform apply
app:
	@echo "Deploying Memphis to EKS"
	./memphis-install.sh
destroy:
    ./memphis-uninstall.sh
	@terraform destroy
    