#!/bin/bash
set -e

: ${LIQUIBASE_DEFAULT_OBJECTS:="tables,columns,views,primaryKeys,indexes,foreignKeys,sequences"}

: ${CHANGELOG_FILE:="changelog.xml"}
: ${CHANGESET_PATH:="$(dirname $SOURCE_PATH/$CHANGELOG_FILE)/changesets"}
: ${CHANGESET_FILE:="$(date +%F_%H-%M-%S).xml"}
: ${LIQUIBASE_AUTHOR:="liquibase"}

if [[ ! -d $CHANGESET_PATH ]]; then
  mkdir -p $CHANGESET_PATH
fi

LIQUIBASE_OPTIONS=" --changeLogFile=${CHANGESET_PATH}/${CHANGESET_FILE} --changeSetAuthor=${LIQUIBASE_AUTHOR}"
LIQUIBASE_CMD_OPTIONS=''

if [[ ! -z $ONLY_DATA ]]; then
    LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --diffTypes=data"
else
  LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --diffTypes=${LIQUIBASE_DEFAULT_OBJECTS}"
fi

if [[ $LIQUIBASE_DEBUG == 1 ]]; then
  LIQUIBASE_OPTIONS="${LIQUIBASE_OPTIONS} --logLevel=debug"
fi

if [[ ! -z $LIQUIBASE_DB_SCHEMA ]]; then
  LIQUIBASE_OPTIONS="${LIQUIBASE_OPTIONS} --defaultSchemaName=${LIQUIBASE_DB_SCHEMA}"
fi

if [[ ! -z $LIQUIBASE_CONTEXT ]]; then
  LIQUIBASE_OPTIONS="${LIQUIBASE_OPTIONS} --contexts=${LIQUIBASE_CONTEXT}"
fi 

# Diff Options
if [[ ! -z $LIQUIBASE_DB_REFERENCE_SCHEMA ]]; then
  LIQUIBASE_CMD_OPTIONS="${LIQUIBASE_CMD_OPTIONS} --referenceDefaultSchemaName=${LIQUIBASE_DB_REFERENCE_SCHEMA}"
fi 

LIQUIBASE_CMD_OPTIONS="${LIQUIBASE_CMD_OPTIONS} --referenceUrl=${LIQUIBASE_DB_REFERENCE_URL}"
LIQUIBASE_CMD_OPTIONS="${LIQUIBASE_CMD_OPTIONS} --referenceUsername=${LIQUIBASE_DB_REFERENCE_USER}"
LIQUIBASE_CMD_OPTIONS="${LIQUIBASE_CMD_OPTIONS} --referencePassword=${LIQUIBASE_DB_REFERENCE_PASS}"

if [[ $LIQUIBASE_DEBUG == 1 ]]; then
  echo liquibase $LIQUIBASE_OPTIONS diffChangeLog $LIQUIBASE_CMD_OPTIONS
fi

liquibase $LIQUIBASE_OPTIONS diffChangeLog $LIQUIBASE_CMD_OPTIONS

if [[ -f ${CHANGESET_PATH}/${CHANGESET_FILE}  ]]; then
    echo 'Changelog gerado em' ${CHANGESET_PATH}/${CHANGESET_FILE}
    sed -i "/<\/databaseChangeLog>/i    <include relativeToChangelogFile=\"true\" file=\"changesets/$CHANGESET_FILE\" />" "${SOURCE_PATH}/${CHANGELOG_FILE}"
fi
