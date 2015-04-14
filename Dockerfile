FROM ubuntu
MAINTAINER Sebastian Rakel <sebastian@devunit.eu>

ENV DEBIAN_FRONTEND noninteractive
ENV SYSDBA_PASSWORD masterkey

RUN apt-get update && \
    apt-get install -qy libncurses5-dev bzip2 curl gcc g++ make && \
    mkdir -p /home/firebird && \
    cd /home/firebird && \
    curl -o firebird-source.tar.bz2 \
        "http://softlayer-dal.dl.sourceforge.net/project/firebird/firebird/2.5.4-Release/Firebird-2.5.4.26856-0.tar.bz2" && \
    tar --strip=1 -xf firebird-source.tar.bz2 && \
    ./configure --prefix=/usr/local/firebird && \
    make && \
    make silent_install && \
    cd / && \
    rm -rf /home/firebird && \
    rm -rf /usr/local/firebird/*/.debug && \
    apt-get purge -qy --auto-remove libncurses5-dev bzip2 curl gcc g++ make  && \
    apt-get clean -q && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/databases"]

EXPOSE 3050/tcp

RUN CURRENT_SYSDBA_PASSWORD=`grep -oP 'ISC_PASSWD=\K.*' /usr/local/firebird/SYSDBA.password` && \
    /usr/local/firebird/bin/gsec -user SYSDBA -password `echo $CURRENT_SYSDBA_PASSWORD` -modify SYSDBA -pw `echo $SYSDBA_PASSWORD`
    
ENTRYPOINT ["/usr/local/firebird/bin/fbguard"]
