FROM ubuntu
WORKDIR "/tmp"
RUN apt update
RUN apt install wget -y
RUN wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar xf install-tl-unx.tar.gz
RUN apt install perl -y
RUN perl /tmp/$(ls | head -1)/install-tl --no-interaction
