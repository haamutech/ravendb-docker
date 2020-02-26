FROM ubuntu:18.04

ENV RAVEN_ARGS='' RAVEN_SETTINGS='' RAVEN_Setup_Mode='Initial' RAVEN_DataDir='RavenData' RAVEN_ServerUrl_Tcp='38888' RAVEN_AUTO_INSTALL_CA='true' RAVEN_IN_DOCKER='true'

EXPOSE 8080 38888 161

ARG TARGETPLATFORM

RUN apt-get update \
    && apt-get install -y \
    && apt-get install --no-install-recommends wget libssl1.0.0 bzip2 libunwind8 libicu60 libcurl3 ca-certificates jq -y \
    && cd /opt \
    && if [ $TARGETPLATFORM = "linux/arm/v7" ]; then wget -O RavenDB.tar.bz2 https://hibernatingrhinos.com/downloads/RavenDB%20for%20Raspberry%20Pi/42034; else wget -O RavenDB.tar.bz2 https://hibernatingrhinos.com/downloads/RavenDB%20for%20Linux%20x64/42034; fi \
    && tar xjvf RavenDB.tar.bz2 \
    && rm RavenDB.tar.bz2 \
    && echo '{"ServerUrl":"http://0.0.0.0:8080","Setup.Mode":"None","Security.UnsecuredAccessAllowed":"PublicNetwork"}' > /opt/RavenDB/Server/settings.json \
    && apt-get remove wget bzip2 -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY run-raven.sh healthcheck.sh /opt/RavenDB/

HEALTHCHECK --start-period=60s CMD /opt/RavenDB/healthcheck.sh

WORKDIR /opt/RavenDB/Server

VOLUME /opt/RavenDB/Server/RavenData /opt/RavenDB/config

CMD /opt/RavenDB/run-raven.sh
