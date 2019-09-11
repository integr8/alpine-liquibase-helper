FROM openjdk:8-alpine
LABEL maintainer="Fábio Luciano <fabio@naoimporta.com>"

ARG LIQUIBASE_VERSION=3.7.0
ARG PGSQL_DRIVER_VERSION=42.2.6
ARG MYSQL_DRIVER_VERSION=8.0.17

ADD files/scripts/* /usr/local/bin/

WORKDIR /opt/

RUN apk add -q --no-cache curl bash git && mkdir -p /opt/liquibase-bin/ \
  && curl -Ls https://github.com/liquibase/liquibase/releases/download/liquibase-parent-${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}-bin.tar.gz > /opt/liquibase-bin/liquibase.tar.gz \
  && tar x -f /opt/liquibase-bin/liquibase.tar.gz -C /opt/liquibase-bin/ \
  && curl -Ls https://jdbc.postgresql.org/download/postgresql-${PGSQL_DRIVER_VERSION}.jar > /opt/liquibase-bin/lib/postgresql.jar \
  && curl -Ls https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz > /opt/liquibase-bin/lib/mysql.tar.gz \
  && tar x -f /opt/liquibase-bin/lib/mysql.tar.gz mysql-connector-java-${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar -C /opt/liquibase-bin/lib/ \
  && mv /opt/liquibase-bin/lib/mysql*/*.jar /opt/liquibase-bin/lib/ \
  && printf "integr8\nintegr8" | adduser integr8 && ln -s /opt/liquibase-bin/liquibase /usr/local/bin \
  && chmod a+x -R /usr/local/bin/ && chown integr8:integr8 /opt -R \
  && rm -rf /opt/liquibase-bin/sdk/javadoc /opt/liquibase-bin/liquibase.tar.gz /opt/liquibase-bin/lib/mysql.tar.gz && rm -rf /var/cache/apk/*

ADD files/libs/ojdbc7.jar /opt/liquibase-bin/lib
ADD files/libs/sqljdbc42.jar /opt/liquibase-bin/lib

USER 1000

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
