#!/bin/bash
set -e

: ${LIQUIBASE_DB_REFERENCE_URL?  "Por favor, informe a URL do banco de referencia" }
: ${LIQUIBASE_DB_REFERENCE_USER? "Por favor, informe o usuário de conexão ao banco de referencia" }
: ${LIQUIBASE_DB_REFERENCE_PASS? "Por favor, informe a senha de conexão ao banco de referencia" }

# Liquibase Options
LIQUIBASE_OPTIONS=''

if [[ $LIQUIBASE_DEBUG == 1 ]]; then
  LIQUIBASE_OPTIONS="${LIQUIBASE_OPTIONS} --logLevel=debug"
fi

if [[ ! -z $LIQUIBASE_DB_SCHEMA ]]; then
  LIQUIBASE_OPTIONS="${LIQUIBASE_OPTIONS} --defaultSchemaName=${LIQUIBASE_DB_SCHEMA}"
fi

if [[ ! -z $LIQUIBASE_CONTEXT ]]; then
  LIQUIBASE_OPTIONS="${LIQUIBASE_OPTIONS} --contexts=${LIQUIBASE_CONTEXT}"
fi 

LIQUIBASE_CMD_OPTIONS=''

# Diff Options
if [[ ! -z $LIQUIBASE_DB_REFERENCE_SCHEMA  ]]; then
  LIQUIBASE_CMD_OPTIONS="${LIQUIBASE_CMD_OPTIONS} --referenceDefaultSchemaName=${LIQUIBASE_DB_REFERENCE_SCHEMA}"
fi 

LIQUIBASE_CMD_OPTIONS="${LIQUIBASE_CMD_OPTIONS} --referenceUrl=${LIQUIBASE_DB_REFERENCE_URL}"
LIQUIBASE_CMD_OPTIONS="${LIQUIBASE_CMD_OPTIONS} --referenceUsername=${LIQUIBASE_DB_REFERENCE_USER}"
LIQUIBASE_CMD_OPTIONS="${LIQUIBASE_CMD_OPTIONS} --referencePassword=${LIQUIBASE_DB_REFERENCE_PASS}"

liquibase $LIQUIBASE_OPTIONS diff $LIQUIBASE_CMD_OPTIONS