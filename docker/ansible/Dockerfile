FROM ubuntu:wily

RUN apt-get update && apt-get install -y \
    software-properties-common \
    apt-utils \
    net-tools \
    iputils-ping \
    vim \
    openssh-client \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN apt-add-repository -y ppa:ansible/ansible

RUN apt-get update && apt-get install -y \
    ansible \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN echo "eval \`ssh-agent\`"  >> /root/.bashrc
RUN echo "ssh-add" >> /root/.bashrc

CMD ["/bin/bash"]
