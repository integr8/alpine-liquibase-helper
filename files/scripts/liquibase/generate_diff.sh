#!/bin/bash
set -e

: ${CHANGELOG_FILE:="changelog.xml"}
: ${CHANGESET_PATH:="$(dirname $SOURCE_PATH/$CHANGELOG_FILE)/changesets"}
: ${CHANGESET_FILE:="changeset_$(date +%F_%H-%M).xml"}
: ${LIQUIBASE_AUTHOR:="liquibase"}

if [[ ! -d $CHANGESET_PATH ]]; then
  mkdir -p $CHANGESET_PATH
fi

LIQUIBASE_OPTIONS=" --changeLogFile=${CHANGESET_PATH}/${CHANGESET_FILE} --changeSetAuthor=${LIQUIBASE_AUTHOR}"

if [[ $LIQUIBASE_DEBUG == 1 ]]; then
  LIQUIBASE_OPTIONS="${LIQUIBASE_OPTIONS} --logLevel=debug"
fi

if [[ ! -z $LIQUIBASE_DB_SCHEMA  ]]; then
  LIQUIBASE_OPTIONS="${LIQUIBASE_OPTIONS} --defaultSchemaName=${LIQUIBASE_DB_SCHEMA}"
fi 

LIQUIBASE_CMD_OPTIONS=''

# Diff Options
if [[ ! -z $LIQUIBASE_DB_REFERENCE_SCHEME  ]]; then
  LIQUIBASE_CMD_OPTIONS="${LIQUIBASE_CMD_OPTIONS} --referenceDefaultSchemaName=${LIQUIBASE_DB_REFERENCE_SCHEME}"
fi 

LIQUIBASE_CMD_OPTIONS="${LIQUIBASE_CMD_OPTIONS} --referenceUrl=${LIQUIBASE_DB_REFERENCE_URL}"
LIQUIBASE_CMD_OPTIONS="${LIQUIBASE_CMD_OPTIONS} --referenceUsername=${LIQUIBASE_DB_REFERENCE_USER}"
LIQUIBASE_CMD_OPTIONS="${LIQUIBASE_CMD_OPTIONS} --referencePassword=${LIQUIBASE_DB_REFERENCE_PASS}"

liquibase $LIQUIBASE_OPTIONS diffChangeLog $LIQUIBASE_CMD_OPTIONS

if [[ -f ${CHANGESET_PATH}/${CHANGESET_FILE}  ]]; then
    echo 'Changelog gerado em' ${CHANGESET_PATH}/${CHANGESET_FILE}
    sed -i "/<\/databaseChangeLog>/i    <include relativeToChangelogFile=\"true\" file=\"changesets/$CHANGESET_FILE\" />" "${SOURCE_PATH}/${CHANGELOG_FILE}"
fi

