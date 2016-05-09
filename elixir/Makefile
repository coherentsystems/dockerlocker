.PHONY: help check-env

VERSION ?= `cat VERSION`
IMAGE_TEST ?= elixir
IMAGE_NAME ?= $(GCORG)/$(IMAGE_TEST)
GCP_NAME ?= $(GCPROJ)
GCC_NAME ?= $(GCCLUS)
GCS_CONTAINER ?= gcr.io/$(GCPROJ)/$(IMAGE_TEST):$(VERSION)
GCS_SERVICE ?= $(GCSERV)

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
ifndef GCSERV
	$(error ENV var GCSERV is undefined, use `export GCSERV=$${Google Compute Service Name}` to fix)
endif

help:
	@echo ""
	@echo "$(IMAGE_NAME):$(VERSION)"
	@echo ""
	@echo "Using this Makefile to build the $(IMAGE_TEST) container bundler"
	@echo "The resulting image can be pushed to google container registry and used for cluster provisioning"
	@echo ""
	@echo "GCPROJ (TopLevel Project Name) -->  GCCLUS (Container Nodes) -->  GCSERV (Name of service that is provisioned on nodes/pods) -->  GC_CONTAINER (image pushed that defines a service)"
	@echo ""
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

build: check-env ## Rebuild the Docker image
	docker build --force-rm -t $(IMAGE_NAME):$(VERSION) -t $(IMAGE_NAME):latest - < ./Dockerfile

test: check-env build ## Test the Docker image
	docker run --rm -it $(IMAGE_NAME):$(VERSION)

gccreds: check-env ## Get Google Container Credentials
	gcloud container clusters get-credentials $(GCC_NAME)

gcitag: check-env build ## Tag the docker image in preparation for a push to gcloud
	docker tag $(IMAGE_NAME):$(VERSION) gcr.io/$(GCP_NAME)/$(IMAGE_TEST):$(VERSION)

gcpush: check-env gcitag ## Push image to gcloud
	gcloud docker -- push gcr.io/$(GCP_NAME)/$(IMAGE_TEST):$(VERSION)

kubeprovision: gcitag gccreds ## Provision image into a Service using Kubernetes kubectl CLI
	kubectl run $(GCS_SERVICE) --image=$(GCS_CONTAINER)

kubedeploy: gccreds ## Deploy a Service using kubectl CLI to `expose the service` to the outside world
	kubectl delete service $(GCS_SERVICE) || true && kubectl expose deployment $(GCS_SERVICE) --port=80 --target-port=$(PORT) --type=\"LoadBalancer\"

kubedit: gccreds ## Edit Kubernetes configuration for Google Container Service (used to update an existing deployment, including reprovisioning via version update)
	kubectl edit deployment