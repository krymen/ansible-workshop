BASE_NODE_NAME = ansible-node

ifeq (ansible-node-up, $(firstword $(MAKECMDGOALS)))
  NAME = $(word 2,$(MAKECMDGOALS))
  ifeq ($(NAME),)
    NAME := $(shell /bin/bash -c "echo $$RANDOM")
  endif
  NODE_NAME = $(BASE_NODE_NAME)-$(NAME)
endif

ifeq (ansible-node-down, $(firstword $(MAKECMDGOALS)))
  NODE_NAME = $(BASE_NODE_NAME)-$(word 2,$(MAKECMDGOALS))
  ifeq ($(NODE_NAME),)
    NODE_NAME = $(BASE_NODE_NAME)
  endif
endif

ANSIBLE_IMAGE           = ansible
ANSIBLE_DOCKER_DIR      = docker/ansible
ANSIBLE_NODE_IMAGE      = ansible-node
ANSIBLE_NODE_IMAGE      = ansible-node
ANSIBLE_NODE_DOCKER_DIR = docker/ansible-node

MOUNT_SSH_KEY           = -v $(HOME)/.ssh/id_rsa:/root/.ssh/id_rsa:ro -v $(HOME)/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub:ro
MOUNT_ANSIBLE_ETC       = -v $(PWD)/ansible/etc:/etc/ansible
MOUNT_AUTHORIZED_KEYS   = -v $(PWD)/ansible/node/authorized_keys:/root/.ssh/authorized_keys

ansible-create-authorized-keys:
	@echo `cat $(HOME)/.ssh/id_rsa.pub` > $(ANSIBLE_NODE_DOCKER_DIR)/authorized_keys

ansible-build-image:
	@docker build -t $(ANSIBLE_IMAGE) $(ANSIBLE_DOCKER_DIR)

ansible-build-node-image: ansible-create-authorized-keys
	@docker build -t $(ANSIBLE_NODE_IMAGE) $(ANSIBLE_NODE_DOCKER_DIR)

ansible-client: ansible-build-image
	@docker run --name=ansible-client --rm -ti $(MOUNT_ANSIBLE_ETC) $(MOUNT_SSH_KEY) $(ANSIBLE_IMAGE)

ansible-node-up: ansible-build-node-image
	@docker run --name=$(NODE_NAME) -d -ti $(ANSIBLE_NODE_IMAGE)
	@docker exec $(NODE_NAME) invoke-rc.d ssh restart
	@echo Node Name: $(NODE_NAME)
	@echo Node IP:   `docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(NODE_NAME)`
#	@echo `docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(NODE_NAME)` >> ansible/etc/hosts

ansible-node-down:
	@docker ps -a | grep $(NODE_NAME) | awk '{ print $$1; }' | xargs docker stop
	@docker ps -a | grep $(NODE_NAME) | awk '{ print $$1; }' | xargs docker rm

ansible-client-down:
	@docker ps -a | grep ansible-client | awk '{ print $$1; }' | xargs docker stop
	@docker ps -a | grep ansible-client | awk '{ print $$1; }' | xargs docker rm

%:
	@:
