FROM gitpod/workspace-node-lts:2022-12-02-22-15-49

USER root

# Install jq (if not done already). Required for the .gitpod.yml tasks below.

RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add - \
     && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list \
     && apt-get update \
     && apt-get install -y tailscale jq \
     && update-alternatives --set ip6tables /usr/sbin/ip6tables-nft

# JDK
RUN sudo apt-get -q update && sudo apt-get -yq install gnupg curl \
    && sudo apt-key adv \
          --keyserver hkp://keyserver.ubuntu.com:80 \
          --recv-keys 0xB1998361219BD9C9 
RUN curl -O https://cdn.azul.com/zulu/bin/zulu-repo_1.0.0-3_all.deb \
     && sudo apt-get install ./zulu-repo_1.0.0-3_all.deb \
     && sudo apt-get update \
     && sudo apt-get -yq install zulu11-jdk

# maven
RUN wget https://mirrors.estointernet.in/apache/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz \
    && tar -xvf apache-maven-3.8.6-bin.tar.gz \
    && mv apache-maven-3.8.6 /opt/ \
    && echo 'export M2_HOME=/opt/apache-maven-3.8.6' >> ~/.bashrc \
    && echo 'export PATH=$M2_HOME/bin:$PATH' >> ~/.bashrc
    
# Install pulumi
RUN curl -fsSL https://get.pulumi.com | sh
RUN echo 'export PATH=$PATH:~/.pulumi/bin' >> ~/.bashrc

# Kubernetes
RUN curl -LO https://dl.k8s.io/release/v1.21.14/bin/linux/amd64/kubectl && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# Using custom location for kubernetes config in order for changes to config to be persistent
RUN mkdir /workspace/.kube && touch /workspace/.kube/config
RUN echo 'export KUBECONFIG=/workspace/.kube/config' >> ~/.bashrc
