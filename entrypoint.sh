#!/bin/bash
set -e

SOURCE_PATH='/opt/source'

cd $SOURCE_PATH

: ${SOURCE_METHOD? "Por favor, informe se será GIT ou VOLUME"}

if [ "$SOURCE_METHOD" == 'GIT' ]; then
    : ${GIT_URL? "Por favor, informe o endereço do repositório do git"}
    : ${GIT_EMAIL? "Por favor, informe o usuário do git"}
    : ${GIT_PASS? "Por favor, informe a senha do usupario do git"}

    git config --global credential.username ${GIT_USER}
    git config --global credential.helper '!f() { echo "password='${GIT_PASS}'"; }; f'
    git config --global http.sslVerify "false"

    rm $SOURCE_PATH -rf
    git clone --progress --verbose ${GIT_URL} $SOURCE_PATH

elif [ "$SOURCE_METHOD" == 'VOLUME' ]; then

    if [ ! -d "$SOURCE_PATH" ]; then
        echo 'Foi informado que o código fonte seria provido por um volume, mas o diretório não existe'
    fi

fi

: ${LIQUIBASE_URL? "Por favor, informe uma string de conexão no padrão jdbc"}
: ${LIQUIBASE_DB_USER? "Por favor, informe o usuário de conexão ao banco"}
: ${LIQUIBASE_DB_PASS? "Por favor, informe a senha de conexão ao banco"}

if [[ "$LIQUIBASE_URL" =~ jdbc:([a-zA-Z]+) ]]; then
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
    esac

    cat <<CONF > ./liquibase.properties
        driver: ${LIQUIBASE_DRIVER}
        url: ${LIQUIBASE_URL}
        username: ${LIQUIBASE_DB_USER}
        password: ${LIQUIBASE_DB_PASS}
CONF
fi
liquibase "$@"