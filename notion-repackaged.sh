#
# This file should only contain variables neccessary for notion-repackaged builds
# To bring these variables to your shell, run "source notion-repackaged.sh"
#

# Version of the original Notion App installer to repackage
export NOTION_VERSION=3.0.0

# Revision of the current version
export NOTION_REPACKAGED_REVISION=1

# The md5sum hash of the downloaded .exe for the installer
export NOTION_DOWNLOAD_HASH=a0d687989346bc1b16d620a0af0f3642

# The commit of notion-enhancer/desktop to target
export NOTION_ENHANCER_DESKTOP_COMMIT=a88c45cc80f0cfd83f205ddfbbca695f50db16ef

# not supported for 3.x.x yet
export NOTION_REPACKAGED_AIO_SKIP_ENHANCED=true