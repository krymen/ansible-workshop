# Ansible workshop

## Requirements
- Generetad SSH key (id_rsa[.pub])
- Installed and running docker (include docker-machine).
- Installed make

## Setting up nodes
`make ansible-node-up [node_name]` - Runs node container. [node_name] is optional, will be random number if not provided.
`make ansible-node-up [node_name]` - Stops and removes node container. If [node_name] provided applies to given else to all nodes.

After running `ansible-node-up` you will se at the end of produced output two important lines:
```
Node Name: ansible-node-3999
Node IP: 172.17.0.2
```

First is docker container name. Second is its IP, that you will later use while wotking with client.

## Setting up client

`make ansible-client` - Runs container with client.
`make ansible-client-down` - Stops and removes container with client.

No you can put your node IP in ansible inventory `/etc/ansible/hosts`, then check if everything is ok with `ansible all -m ping` from within client container.

Have fun :)