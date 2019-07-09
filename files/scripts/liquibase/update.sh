#!/bin/bash
set -e

: ${CHANGELOG_FILE:="changelog.xml"}

LIQUIBASE_OPTIONS=" --changeLogFile=${SOURCE_PATH}/${CHANGELOG_FILE}"

if [[ $LIQUIBASE_DEBUG == 1 ]]; then
  LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --logLevel=debug"
fi

if [[ ! -z $LIQUIBASE_DB_SCHEMA ]]; then
  LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --defaultSchemaName=${LIQUIBASE_DB_SCHEMA}"
fi

if [[ ! -z $LIQUIBASE_CONTEXT ]]; then
  LIQUIBASE_OPTIONS="${LIQUIBASE_OPTIONS} --contexts=${LIQUIBASE_CONTEXT}"
fi 

if [[ $LIQUIBASE_DEBUG == 1 ]]; then
  echo liquibase $LIQUIBASE_OPTIONS update
fi

liquibase $LIQUIBASE_OPTIONS update
