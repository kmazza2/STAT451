FROM ubuntu:jammy
WORKDIR /STAT451
RUN apt update && apt-get install -y git python3 python3-pip && pip3 install numpy==1.24 && pip3 install scipy==1.10 && git clone https://github.com/kmazza2/STAT451.git
