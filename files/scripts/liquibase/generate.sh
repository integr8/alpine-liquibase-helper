#!/bin/bash
set -e

: ${CHANGELOG_FILE:="changeset_$(date +%F_%H-%M).xml"}
: ${LIQUIBASE_AUTHOR:="liquibase"}

LIQUIBASE_OPTIONS=" --changeLogFile=${LIQUIBASE_ASSETS_PATH}/${CHANGELOG_FILE} --changeSetAuthor=${LIQUIBASE_AUTHOR}"

if [[ $LIQUIBASE_DEBUG == 1 ]]; then
    LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --logLevel=debug"
fi

if [[ ! -z $LIQUIBASE_DB_SCHEMA  ]]; then
  LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --defaultSchemaName=${LIQUIBASE_DB_SCHEMA}"
fi

liquibase $LIQUIBASE_OPTIONS generateChangeLog

if [[ -f ${LIQUIBASE_ASSETS_PATH}/${CHANGELOG_FILE}  ]]; then
    echo 'Changelog gerado em' ${LIQUIBASE_ASSETS_PATH}/${CHANGELOG_FILE}
fi
