USER root

# Install jq (if not done already). Required for the .gitpod.yml tasks below.

RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add - \
     && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list \
     && apt-get update \
     && apt-get install -y tailscale jq \
     && update-alternatives --set ip6tables /usr/sbin/ip6tables-nft
     
RUN curl -fsSL https://get.pulumi.com | sh
