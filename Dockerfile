FROM ubuntu:16.04

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

USER root
ENV LD_LIBRARY_PATH /usr/local/lib

    # add build tools and python
RUN apt-get install -y --allow-unauthenticated build-essential findutils python3 python3-pip wget curl make git patch flex gfortran && \
    mkdir -p /usr/local/src && \
    cd /usr/local/src && \
    
    # download and install OpenMPI 2.1.1
    wget -O /usr/local/src/openmpi-2.1.1.tar.gz https://www.open-mpi.org/software/ompi/v2.1/downloads/openmpi-2.1.1.tar.gz && \
    tar xzvf openmpi-2.1.1.tar.gz
    cd /home/openmpi-2.1.1 && \
    ./configure && \
    make -j 5 install && \
    
    # funwave-tvd
RUN git clone https://github.com/fengyanshi/FUNWAVE-TVD /usr/local/src/FUNWAVE-TVD && \
    cd /usr/local/src/FUNWAVE-TVD/src &&\
    perl -p -i -e 's/FLAG_8 = -DCOUPLING/#$&/' Makefile
    make

WORKDIR usr/local/src/

CMD ["./funwave_vessel", "-h"]
