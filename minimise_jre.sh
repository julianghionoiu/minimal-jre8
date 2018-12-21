#!/usr/bin/env bash

set -e

SCRIPT_CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_CURRENT_DIR}/build"
mkdir -p "${BUILD_DIR}"

TARGET_PLATFORM="$1"
CONFIG_DIR="${SCRIPT_CURRENT_DIR}/config/${TARGET_PLATFORM}"

# Prepare locations
ARTIFACT_NAME="jre1.8.0_191-${TARGET_PLATFORM}"
ORIGINAL_JAR_FILE="${ARTIFACT_NAME}-x64.zip"
MINIMISED_JAR_FILE="${ARTIFACT_NAME}-x64-minimal.zip"
REMOTE_FILE="https://s3.eu-west-2.amazonaws.com/jre.download/jre8/original/${ORIGINAL_JAR_FILE}"
MINIMAL_JRE_PATH="${BUILD_DIR}/${MINIMISED_JAR_FILE}"

echo "Download dependency from ${REMOTE_FILE}"
${SCRIPT_CURRENT_DIR}/download.sh "${REMOTE_FILE}" "${MINIMAL_JRE_PATH}"

echo "Minimise the JRE at ${MINIMAL_JRE_PATH}"
for i in `cat ${CONFIG_DIR}/excludes.txt`; do
    zip -d "${MINIMAL_JRE_PATH}" "${i}" || true
done

# Test JAR
echo "Test the JAR file"
EXPECTED_MINIMISED_SIZE=$(cat ${CONFIG_DIR}/expected_size.txt)
echo "EXPECTED_MINIMISED_SIZE=${EXPECTED_MINIMISED_SIZE}"
ACTUAL_SIZE=$(stat -f %z "${MINIMAL_JRE_PATH}")
echo "ACTUAL_SIZE=${ACTUAL_SIZE}"
if [ ${ACTUAL_SIZE} -gt ${EXPECTED_MINIMISED_SIZE} ]; then
    echo "!! Minimised JRE file size greater that expected size ( ${ACTUAL_SIZE} > ${EXPECTED_MINIMISED_SIZE} )"
    exit 1
else
    echo "All good"
fi


