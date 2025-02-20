
.PHONY: tf-apply
tf-apply:
	./scripts/infra-apply.sh

.PHONY: tf-destroy
tf-destroy:
	./scripts/infra-destroy.sh

.PHONY: stop
stop:
	./scripts/infra-stop.sh

.PHONY: start
start:
	./scripts/infra-start.sh

.PHONY: bootstrap-dev
bootstrap-dev:
	./scripts/bootstrap-flux.sh dev

.PHONY: bootstrap-staging
bootstrap-staging:
	./scripts/bootstrap-flux.sh staging