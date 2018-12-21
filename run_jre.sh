#!/usr/bin/env bash

set -xe

SCRIPT_CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN_TEMP_DIR="${SCRIPT_CURRENT_DIR}/run_tmp"
rm -Rf "${RUN_TEMP_DIR}"
mkdir -p "${RUN_TEMP_DIR}"

PACKED_JRE="$1"

# Extract
unzip "${PACKED_JRE}" -d "${RUN_TEMP_DIR}"

# Invoke JRE
"${RUN_TEMP_DIR}/bin/java" -version
