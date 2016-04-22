FROM debian:8

RUN apt-get update && apt-get install -y \
    openssh-server \
    python \
    vim \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

RUN mkdir /root/.ssh

ADD authorized_keys /root/.ssh/authorized_keys

CMD ["/bin/bash"]
