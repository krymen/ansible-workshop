BASE_NODE_NAME = ansible-node

ANSIBLE_IMAGE           = ansible
ANSIBLE_DOCKER_DIR      = docker/ansible

MOUNT_SSH_KEY           = -v $(HOME)/.vagrant.d/insecure_private_key:/root/.ssh/id_rsa:ro
MOUNT_ANSIBLE_ETC       = -v $(PWD)/ansible/etc:/etc/ansible

ansible-build-image:
	@docker build -t $(ANSIBLE_IMAGE) $(ANSIBLE_DOCKER_DIR)

ansible-client: ansible-build-image
	@docker run --name=ansible-client --rm -ti $(MOUNT_ANSIBLE_ETC) $(MOUNT_SSH_KEY) $(ANSIBLE_IMAGE)

ansible-client-down:
	@docker ps -a | grep ansible-client | awk '{ print $$1; }' | xargs docker stop
	@docker ps -a | grep ansible-client | awk '{ print $$1; }' | xargs docker rm

%:
	@:
