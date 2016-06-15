.PHONY: help check-env

VERSION ?= `cat VERSION`
IMAGE_TEST ?= postgres
IMAGE_NAME ?= $(GCORG)/$(IMAGE_TEST)
GCP_NAME ?= $(GCPROJ)
GCC_NAME ?= $(GCCLUS)
GCS_CONTAINER ?= gcr.io/$(GCPROJ)/$(IMAGE_TEST):$(VERSION)
GCS_SERVICE ?= postgres
GCZONE ?= us-central1-b
GCDISK ?= postgres-data
PORT ?= 5432
PGDATA_MOUNT ?= /postgres/var/lib/postgresql/data
GCSP_VOLUME ?= /mnt/pg-data-persistent
DATA_VOLUME ?= /Users/$(USER)/Documents/Kitematic/postgres/var/lib/postgresql/data

check-env:
ifndef GCORG
	$(error ENV var GCORG is undefined, use `export GCORG=$${Google Compute Org Name}` to fix)
endif
ifndef GCPROJ
	$(error ENV var GCPROJ is undefined, use `export GCPROJ=$${Google Compute Project Name}` to fix)
endif
ifndef GCCLUS
	$(error ENV var GCCLUS is undefined, use `export GCCLUS=$${Google Compute Cluster Name}` to fix)
endif

help:
	@echo ""
	@echo "$(IMAGE_NAME):$(VERSION)"
	@echo ""
	@echo "Using this Makefile to build the $(IMAGE_TEST) container bundler"
	@echo "The resulting image can be pushed to google container registry and used for cluster provisioning"
	@echo ""
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

build: ## Rebuild the Docker image
	docker build --force-rm -t $(IMAGE_NAME):$(VERSION) -t $(IMAGE_NAME):latest .

test: build ## Test the Docker image
	docker run --rm -it -e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) -e PGDATA=$(PGDATA_MOUNT) -v "$(DATA_VOLUME):$(PGDATA_MOUNT):rw" --name $(IMAGE_TEST)  -p $(PORT):$(PORT) $(IMAGE_NAME):$(VERSION) && tail -f /dev/null

dev: build ## Run the Docker image in DEV mode
	docker run -d -e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) -e PGDATA=$(PGDATA_MOUNT) -v "$(DATA_VOLUME):$(PGDATA_MOUNT):rw" --name $(IMAGE_TEST) -p $(PORT):$(PORT) $(IMAGE_NAME):$(VERSION)

explore: build ## Run the Docker image in exploration mode
	docker run --rm -it -e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) -e PGDATA=$(PGDATA_MOUNT) -v "$(DATA_VOLUME):$(PGDATA_MOUNT):rw" --entrypoint "/bin/sh" --name $(IMAGE_TEST) -p $(PORT):$(PORT) $(IMAGE_NAME):$(VERSION)

gccreds: check-env ## Get Google Container Credentials
	gcloud container clusters get-credentials $(GCC_NAME)

gcitag: check-env build ## Tag the docker image in preparation for a push to gcloud
	docker tag $(IMAGE_NAME):$(VERSION) gcr.io/$(GCP_NAME)/$(IMAGE_TEST):$(VERSION)

gcpush: check-env gcitag ## Push image to gcloud
	gcloud docker -- push gcr.io/$(GCP_NAME)/$(IMAGE_TEST):$(VERSION)

gcdiskprovision: check-env ## Provision the virtual disk
	gcloud compute --project $(GCP_NAME) disks create $(GCDISK) --size "500" --zone $(GCZONE) --description "Postgres data storage" --type "pd-standard"

gcdiskattach: check-env gcdiskprovision ## Attach provisioned disk
	gcloud compute instances attach-disk ??INSTANCE --disk $(GCDISK) --zone $(GCZONE)

kubeprovision: gcitag gccreds ## Provision image into a Service using Kubernetes kubectl CLI
	kubectl run $(GCS_SERVICE) --image=$(GCS_CONTAINER)

kubeprovisionpostgres: gcitag gccreds ## Provision a specific postgres instance
	kubectl run $(GCS_SERVICE) --image=$(GCS_CONTAINER) --env="PGDATA=$(GCSP_VOLUME)" --port=$(PORT)

kubedeploy: gccreds ## Deploy a Service using kubectl CLI to `expose the service` to the outside world
	kubectl delete service $(GCS_SERVICE) || true && kubectl expose deployment $(GCS_SERVICE) --port=80 --target-port=$(PORT) --type=\"LoadBalancer\"

kubedit: gccreds ## Edit Kubernetes configuration for Google Container Service (used to update an existing deployment, including reprovisioning via version update)
	kubectl edit deployment