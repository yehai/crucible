FROM blacklabelops/java:openjre8
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

ARG CRUCIBLE_VERSION=3.10.3
# permissions
ARG CONTAINER_UID=1000
ARG CONTAINER_GID=1000

ENV CRUCIBLE_HOME=/var/atlassian/crucible \
    FISHEYE_INST=/opt/crucible \
    CRUCIBLE_PROXY_NAME= \
    CRUCIBLE_PROXY_PORT= \
    CRUCIBLE_PROXY_SCHEME=

RUN export MYSQL_DRIVER_VERSION=5.1.38 && \
    export POSTGRESQL_DRIVER_VERSION=9.4.1207 && \
    export CONTAINER_USER=crucible &&  \
    export CONTAINER_GROUP=crucible &&  \
    addgroup -g $CONTAINER_GID $CONTAINER_GROUP &&  \
    adduser -u $CONTAINER_UID \
            -G $CONTAINER_GROUP \
            -h /home/$CONTAINER_USER \
            -s /bin/bash \
            -S $CONTAINER_USER &&  \
    apk add --update \
      ca-certificates \
      unzip \
      wget &&  \
    apk add xmlstarlet --update-cache \
      --repository \
      http://dl-3.alpinelinux.org/alpine/edge/testing/ \
      --allow-untrusted &&  \
    wget -O /tmp/crucible.zip https://www.atlassian.com/software/crucible/downloads/binary/crucible-${CRUCIBLE_VERSION}.zip && \
    unzip /tmp/crucible.zip -d /tmp && \
    mv /tmp/fecru-${CRUCIBLE_VERSION} /tmp/crucible && \
    mkdir -p ${CRUCIBLE_HOME} && \
    mkdir -p /opt && \
    mv /tmp/crucible /opt/crucible && \
    # Install database drivers
    rm -f                                               \
      ${FISHEYE_INST}/lib/mysql-connector-java*.jar &&  \
    wget -O /tmp/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz                                              \
      http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz && \
    tar xzf /tmp/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz                                              \
      -C /tmp && \
    cp /tmp/mysql-connector-java-${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}-bin.jar     \
      ${FISHEYE_INST}/lib/mysql-connector-java-${MYSQL_DRIVER_VERSION}-bin.jar                                &&  \
    rm -f ${FISHEYE_INST}/lib/postgresql-*.jar                                                                &&  \
    wget -O ${FISHEYE_INST}/lib/postgresql-${POSTGRESQL_DRIVER_VERSION}.jar                                       \
      https://jdbc.postgresql.org/download/postgresql-${POSTGRESQL_DRIVER_VERSION}.jar && \
    # Adding letsencrypt-ca to truststore
    wget -O /home/${CONTAINER_USER}/letsencryptauthorityx1.der https://letsencrypt.org/certs/letsencryptauthorityx1.der && \
    keytool -trustcacerts -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit -noprompt -importcert -file /home/${CONTAINER_USER}/letsencryptauthorityx1.der && \
    rm -f /home/${CONTAINER_USER}/letsencryptauthorityx1.der && \
    # Install atlassian ssl tool
    wget -O /home/${CONTAINER_USER}/SSLPoke.class https://confluence.atlassian.com/kb/files/779355358/SSLPoke.class && \
    # Container user permissions
    chown -R crucible:crucible /home/${CONTAINER_USER} && \
    chown -R crucible:crucible ${CRUCIBLE_HOME} && \
    chmod -R u=rwx,g=rwx,o=-rwx ${FISHEYE_INST} && \
    chown -R crucible:crucible ${FISHEYE_INST} && \
    # Remove obsolete packages
    apk del \
      ca-certificates \
      unzip \
      wget &&  \
    # Clean caches and tmps
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /var/log/*

USER crucible
WORKDIR /var/atlassian/crucible
VOLUME ["/var/atlassian/crucible"]
EXPOSE 8060
COPY imagescripts /home/crucible
ENTRYPOINT ["/home/crucible/docker-entrypoint.sh"]
CMD ["crucible"]
