.PHONY: help check-env

VERSION ?= `cat VERSION`
IMAGE_TEST ?= xapi
IMAGE_NAME ?= $(GCORG)/$(IMAGE_TEST)
GCP_NAME ?= $(GCPROJ)
GCC_NAME ?= $(GCCLUS)
GCS_CONTAINER ?= gcr.io/$(GCPROJ)/$(IMAGE_TEST):$(VERSION)
PORT ?= 9999

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
	@echo "GCPROJ (TopLevel Project Name) -->  GCCLUS (Container Nodes) -->  GCSERV (Name of service that is provisioned on nodes/pods) -->  GC_CONTAINER (image pushed that defines a service)"
	@echo ""
	@echo ""
	@echo ""
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'


gccreds: check-env ## Get Google Container Credentials
	gcloud container clusters get-credentials $(GCC_NAME)

gcitag: check-env ## Tag the docker image in preparation for a push to gcloud
	docker tag $(IMAGE_NAME):$(VERSION) $(GCS_CONTAINER)

gcpush: check-env  ## Push image to gcloud
	gcloud docker -- push $(GCS_CONTAINER)