FROM openjdk:8-alpine
LABEL maintainer="Fábio Luciano"

ADD files/liquibase-3.5.5-bin.tar.gz /opt/liquibase
ADD files/mysql-connector-java-5.1.45-bin.jar /opt/liquibase/lib
ADD files/ojdbc8.jar /opt/liquibase/lib
ADD files/postgresql-42.1.4.jar /opt/liquibase/lib
ADD entrypoint.sh /usr/local/bin/

WORKDIR /opt

RUN apk add --no-cache bash git \
    && ln -s /opt/liquibase/liquibase /usr/local/bin \
    && chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]