#!/usr/bin/env bash
set -e

source `dirname $0`/_utils.sh
workdir ${WORKSPACE_BUILD_DIR}

check-cmd 7z jq convert sponge
check-env NOTION_VERSION NOTION_REPACKAGED_REVISION

if [ -d "${NOTION_EXTRACTED_EXE_NAME}" ]; then
  log "Removing already extracted exe contents..."
  rm -r "${NOTION_EXTRACTED_EXE_NAME}"
fi

export NOTION_DOWNLOADED_NAME="Notion-${NOTION_VERSION}.exe"
log "Extracting Windows installer contents..."

7z x -y "${NOTION_DOWNLOADED_NAME}" \
  -o"${NOTION_EXTRACTED_EXE_NAME}" > /dev/null

if [ -d "${NOTION_EXTRACTED_APP_NAME}" ]; then
  log "Removing already extracted app contents..."
  rm -r "${NOTION_EXTRACTED_APP_NAME}"
fi

log "Extracting Windows app resources..."
7z x -y "${NOTION_EXTRACTED_EXE_NAME}/\$PLUGINSDIR/app-64.7z" \
  -o"${NOTION_EXTRACTED_APP_NAME}" > /dev/null

if [ -d "${NOTION_VANILLA_SRC_NAME}" ]; then
  log "Removing already extracted app sources..."
  rm -r "${NOTION_VANILLA_SRC_NAME}"
fi

log "Extracting asar..."
asar extract "${NOTION_EXTRACTED_APP_NAME}/resources/app.asar" "${NOTION_EXTRACTED_APP_NAME}/resources/app"

log "Copying original app resources..."
cp -r  "${NOTION_EXTRACTED_APP_NAME}/resources/app/" "${NOTION_VANILLA_SRC_NAME}"
rm "${NOTION_VANILLA_SRC_NAME}"/icon*
cp $WORKSPACE_DIR/logo.png "${NOTION_VANILLA_SRC_NAME}"/icon.png

export NOTION_REPACKAGED_VERSION_REV="${NOTION_VERSION}-${NOTION_REPACKAGED_REVISION}"

pushd "${NOTION_VANILLA_SRC_NAME}" > /dev/null

log "Patching and cleaning source"

rm -r node_modules

find . -type f -name "*.js.map" -exec rm {} +

log "Adapting package.json including fixes..."

jq \
  --arg homepage "${NOTION_REPACKAGED_HOMEPAGE}" \
  --arg repo "${NOTION_REPACKAGED_REPO}" \
  --arg author "${NOTION_REPACKAGED_AUTHOR}" \
  --arg version "${NOTION_REPACKAGED_VERSION_REV}" \
  '.name="notion-app" |
  .homepage=$homepage | 
  .repository=$repo | 
  .author=$author | 
  .version=$version' \
  package.json | sponge package.json

popd > /dev/null
