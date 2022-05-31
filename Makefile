SHELL := /bin/bash -eu

HADOLINT_VERSION      := 2.10.0
SHELLCHECK_VERSION    := 0.8.0
HARDWARE_NAME         := $(shell uname -m)
SYSTEM_NAME           := $(shell uname -s | tr A-Z a-z)

tools: tools/golangci-lint/$(GOLANGCI_LINT_VERSION)/golangci-lint tools/helm/$(HELM_VERSION)/helm tools/hadolint/$(HADOLINT_VERSION)/hadolint tools/shellcheck-stable/shellcheck

tools/hadolint/$(HADOLINT_VERSION)/hadolint:
	mkdir -p tools/hadolint/$(HADOLINT_VERSION)/
	curl -sSLf -o tools/hadolint/$(HADOLINT_VERSION)/hadolint https://github.com/hadolint/hadolint/releases/download/v$(HADOLINT_VERSION)/hadolint-$(SYSTEM_NAME)-$(HARDWARE_NAME)
	chmod +x tools/hadolint/$(HADOLINT_VERSION)/hadolint

tools/shellcheck-stable/shellcheck:
	mkdir -p tools/
	curl -sSLf -o tools/shellcheck-v$(SHELLCHECK_VERSION).$(SYSTEM_NAME).$(HARDWARE_NAME).tar.xz https://github.com/koalaman/shellcheck/releases/download/v$(SHELLCHECK_VERSION)/shellcheck-v$(SHELLCHECK_VERSION).$(SYSTEM_NAME).$(HARDWARE_NAME).tar.xz
	(cd tools && tar -xf shellcheck-v$(SHELLCHECK_VERSION).$(SYSTEM_NAME).$(HARDWARE_NAME).tar.xz)
	rm tools/shellcheck*.tar.xz

.PHONY: lint-docker
lint-docker: tools/hadolint/$(HADOLINT_VERSION)/hadolint
	find . | grep -i dockerfile | xargs ./tools/hadolint/$(HADOLINT_VERSION)/hadolint

.PHONY: lint-shell
lint-shell: tools/shellcheck-stable/shellcheck
	find . | grep '\.sh' | xargs tools/shellcheck-v$(SHELLCHECK_VERSION)/shellcheck
