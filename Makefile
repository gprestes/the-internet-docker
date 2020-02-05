SHELL := /bin/bash -eu

HADOLINT_VERSION      := 1.17.4
HARDWARE_NAME         := $(shell uname -m)
SYSTEM_NAME           := $(shell uname -s | tr A-Z a-z)

tools: tools/golangci-lint/$(GOLANGCI_LINT_VERSION)/golangci-lint tools/helm/$(HELM_VERSION)/helm tools/hadolint/$(HADOLINT_VERSION)/hadolint tools/shellcheck-stable/shellcheck

tools/hadolint/$(HADOLINT_VERSION)/hadolint:
	mkdir -p tools/hadolint/$(HADOLINT_VERSION)/
	curl -sSLf -o tools/hadolint/$(HADOLINT_VERSION)/hadolint https://github.com/hadolint/hadolint/releases/download/v$(HADOLINT_VERSION)/hadolint-$(SYSTEM_NAME)-$(HARDWARE_NAME)
	chmod +x tools/hadolint/$(HADOLINT_VERSION)/hadolint

tools/shellcheck-stable/shellcheck:
	mkdir -p tools/
	curl -sSLf -o tools/shellcheck-stable.$(SYSTEM_NAME).$(HARDWARE_NAME).tar.xz https://storage.googleapis.com/shellcheck/shellcheck-stable.$(SYSTEM_NAME).$(HARDWARE_NAME).tar.xz
	(cd tools && tar -xf shellcheck-stable.$(SYSTEM_NAME).$(HARDWARE_NAME).tar.xz)
	rm tools/shellcheck-stable.*.tar.xz

.PHONY: lint-docker
lint-docker: tools/hadolint/$(HADOLINT_VERSION)/hadolint
	find . | grep -i dockerfile | xargs ./tools/hadolint/$(HADOLINT_VERSION)/hadolint

.PHONY: lint-shell
lint-shell: tools/shellcheck-stable/shellcheck
	find . | grep '\.sh' | xargs tools/shellcheck-stable/shellcheck
