FROM ubuntu:16.04
WORKDIR /root
RUN apt-get update && apt-get install -y \
  bison \
  flex \
  gcc \
  g++ \
  git \
  libgmp-dev \
  libssl-dev \
  make \
  python \
  nano \
  vim
ADD smc2/ smc2
ADD README.md .
ADD /Docker/install.sh install.sh
RUN ["bash", "install.sh"]
CMD ["/bin/bash"]

