FROM debian:bullseye
RUN apt-get update && apt-get install -y wget default-jre procps
RUN wget https://raw.githubusercontent.com/truwl/nfcore-config/main/truwl.nf.config
RUN wget https://github.com/nf-core/methylseq/archive/refs/tags/1.6.1.tar.gz
RUN tar -xvf 1.6.1.tar.gz
RUN wget -qO- https://get.nextflow.io | bash
        