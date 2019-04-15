BASE_NAMESPACE ?= pcr-internal.puppet.net/pe-and-platform
git_describe = $(shell git describe)
vcs_ref := $(shell git rev-parse HEAD)
build_date := $(shell date -u +%FT%T)
hadolint_available := $(shell hadolint --help > /dev/null 2>&1; echo $$?)
hadolint_command := hadolint --ignore DL3008 --ignore DL3018 --ignore DL4000 --ignore DL4001
hadolint_container := hadolint/hadolint:latest
version = $(shell echo $(git_describe) | sed 's/-.*//')
agent_branches := 1.10.x 5.5.x 6.0.x 6.4.x master

prep:
	@git fetch --unshallow ||:
	@git fetch origin 'refs/tags/*:refs/tags/*'

lint:
ifeq ($(hadolint_available),0)
	@$(hadolint_command) runtime/Dockerfile
else
	@docker pull $(hadolint_container)
	@docker run --rm -v $(PWD)/runtime/Dockerfile:/Dockerfile \
		-i $(hadolint_container) $(hadolint_command) Dockerfile
endif

build: prep build-agent-runtimes

build-agent-runtimes: prep
	@for branch in $(agent_branches); do \
		docker build \
			--pull \
			--build-arg vcs_ref=$(vcs_ref) \
			--build-arg build_date=$(build_date) \
			--build-arg version=$(version) \
			--build-arg "project_branch=$$branch" \
	  	--build-arg "project=agent" \
			--tag $(BASE_NAMESPACE)/agent-runtime-$$branch:$(version) \
			runtime; \
		done
