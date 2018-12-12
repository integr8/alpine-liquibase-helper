#!/bin/bash
set -e

export SOURCE_PATH='/opt/source'
export LIQUIBASE_ASSETS_PATH='/opt/liquibase'
export BINARY_PATH=$(dirname "$0")

mkdir -p $LIQUIBASE_ASSETS_PATH

source $BINARY_PATH/configure.sh
source $BINARY_PATH/sources.sh

case "$1" in
    cmd|command|raw)
        $BINARY_PATH/command.sh "${@:2}"
        ;;
    status)
        $BINARY_PATH/status.sh
        ;;
    diff)
        $BINARY_PATH/diff.sh
        ;;
    generateDiff)
        $BINARY_PATH/generate_diff.sh
        ;;
    update)
        $BINARY_PATH/update.sh
        ;;
    generate)
        $BINARY_PATH/generate.sh
        ;;
    report|dbdoc)
        $BINARY_PATH/dbdoc.sh
        ;;
    *)
        echo 'Aparentemente você não sabe o que está fazendo'
esac