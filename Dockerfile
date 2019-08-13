FROM openjdk:8-alpine
LABEL maintainer="Fábio Luciano <fabio@naoimporta.com>"

ADD files/libs/liquibase-3.6.3-bin.tar.gz /opt/liquibase-bin/
ADD files/libs/mysql-connector-java-5.1.45-bin.jar files/libs/ojdbc7.jar \
    files/libs/postgresql-42.2.6.jar /opt/liquibase-bin/lib/
ADD files/scripts/* /usr/local/bin/

WORKDIR /opt//usr/bin/psql

RUN apk add --no-cache bash git \
    && printf "integr8\nintegr8" | adduser integr8 \
    && ln -s /opt/liquibase-bin/liquibase /usr/local/bin \
    && chmod a+x -R /usr/local/bin/ && chown integr8:integr8 /opt -R \
    && rm -rf /var/cache/apk/*

USER 1000

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
