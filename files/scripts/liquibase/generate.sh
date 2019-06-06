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

LIQUIBASE_OPTIONS=" --changeLogFile=${CHANGESET_PATH}/${CHANGESET_FILE} --changeSetAuthor=${LIQUIBASE_AUTHOR} "
LIQUIBASE_CMD_OPTIONS=''

if [[ ! -z $ONLY_DATA ]]; then
    LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --diffTypes=data"
else
  LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --diffTypes=${LIQUIBASE_DEFAULT_OBJECTS}"
fi

if [[ $LIQUIBASE_DEBUG == 1 ]]; then
    LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --logLevel=debug"
fi

if [[ ! -z "$LIQUIBASE_DB_SCHEMA" ]]; then
  LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --defaultSchemaName=${LIQUIBASE_DB_SCHEMA}"
fi

if [[ ! -z $LIQUIBASE_CONTEXT ]]; then
  LIQUIBASE_OPTIONS="${LIQUIBASE_OPTIONS} --contexts=${LIQUIBASE_CONTEXT}"
fi

if [[ $LIQUIBASE_DEBUG == 1 ]]; then
  echo liquibase $LIQUIBASE_OPTIONS generateChangeLog $LIQUIBASE_CMD_OPTIONS
fi

liquibase $LIQUIBASE_OPTIONS generateChangeLog $LIQUIBASE_CMD_OPTIONS

if [[ -f ${SOURCE_PATH}/${CHANGESET_FILE}  ]]; then
    echo 'Changelog gerado em' ${SOURCE_PATH}/${CHANGESET_FILE}
fi

if [[ ! -f  $SOURCE_PATH/$CHANGELOG_FILE ]]; then
    cp $BINARY_PATH/changelog.template.xml $SOURCE_PATH/$CHANGELOG_FILE 
fi

sed -i "/<\/databaseChangeLog>/i <include relativeToChangelogFile=\"true\" file=\"changesets/$CHANGESET_FILE\" />" "${SOURCE_PATH}/${CHANGELOG_FILE}"
