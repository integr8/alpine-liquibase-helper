#!/bin/bash
set -e

export SOURCE_PATH='/opt/source'
export LIQUIBASE_ASSETS_PATH='/opt/liquibase'
export BINARY_PATH=$(dirname "$0")

mkdir -p $LIQUIBASE_ASSETS_PATH

source $BINARY_PATH/liquibase_configure.sh

case "$1" in
    cmd|command)
        $BINARY_PATH/liquibase_command.sh "${@:2}"
        ;;
    status)
        $BINARY_PATH/liquibase_status.sh
        ;;
    diff)
        $BINARY_PATH/liquibase_diff.sh
        ;;
    generateDiff)
        $BINARY_PATH/liquibase_generate_diff.sh
        ;;
    update)
        $BINARY_PATH/liquibase_update.sh
        ;;
    generate)
        $BINARY_PATH/liquibase_generate.sh
        ;;
    report|dbdoc)
        $BINARY_PATH/liquibase_dbdoc.sh
        ;;
    *)
        echo 'Aparentemente você não sabe o que está fazendo'
esac