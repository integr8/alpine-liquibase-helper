#!/bin/bash
set -e

: ${LIQUIBASE_DB_URL?  "Por favor, informe uma string de conexão no padrão jdbc" }
: ${LIQUIBASE_DB_USER? "Por favor, informe o usuário de conexão ao banco" }
: ${LIQUIBASE_DB_PASS? "Por favor, informe a senha de conexão ao banco" }

if [[ "$LIQUIBASE_DB_URL" =~ jdbc:([a-zA-Z]+) ]]; then
    LIQUIBASE_SGBD=${BASH_REMATCH[1]}

    case "$LIQUIBASE_SGBD" in
    "oracle")
        LIQUIBASE_DRIVER='oracle.jdbc.OracleDriver'
        ;;
    "postgresql")
        LIQUIBASE_DRIVER='org.postgresql.Driver'
        ;;
    "mysql")
        LIQUIBASE_DRIVER='com.mysql.jdbc.Driver'
        ;;
    "sqlserver")
        LIQUIBASE_DRIVER='com.microsoft.sqlserver.jdbc.SQLServerDriver'
        ;;
    esac

     echo -e "driver: ${LIQUIBASE_DRIVER}\nurl: ${LIQUIBASE_DB_URL}\nusername: ${LIQUIBASE_DB_USER}\npassword: ${LIQUIBASE_DB_PASS}" > /opt/liquibase.properties
fi
