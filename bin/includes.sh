#!/usr/bin/env bash
set -e

source "/env.sh"

function get_variable {
    VAR_NAME="$1"
    echo "${!VAR_NAME}"
    return 0
}