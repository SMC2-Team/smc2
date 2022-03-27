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
  python3 \
  nano \
  vim \
  psmisc \
  python3-matplotlib \
  python3-pip
ADD smc2/ smc2
ADD /Docker/README.md README.md
ADD /Docker/install.sh install.sh
ADD /Docker/runBenchmarks.sh runBenchmarks.sh
ADD /Docker/plot.py plot.py
RUN ["pip3", "install", "statistics"]
RUN ["bash", "install.sh"]
CMD ["/bin/bash"]

