IMAGE_NAME ?= ghcr.io/krystal/actions-runner:latest

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: versions.json
versions.json:
	docker run --rm \
		-v $(CURDIR)/scripts/extract-versions.sh:/extract-versions.sh \
		$(IMAGE_NAME) /extract-versions.sh > versions.json
	@echo "Version information saved to versions.json"

.PHONY: clean
clean:
	-rm -f versions.json
