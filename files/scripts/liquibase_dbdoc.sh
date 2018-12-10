#!/bin/bash
set -e

: ${CHANGELOG_FILE? "Por favor, informe um arquivo de  "}

LIQUIBASE_OPTIONS=" --changeLogFile=${SOURCE_PATH}/${CHANGELOG_FILE}"

if [[ $LIQUIBASE_DEBUG == 1 ]]; then
  LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --logLevel=debug"
fi

if [[ ! -z $LIQUIBASE_DB_SCHEMA  ]]; then
  LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --defaultSchemaName=${LIQUIBASE_DB_SCHEMA}"
fi

liquibase $LIQUIBASE_OPTIONS dbDoc
