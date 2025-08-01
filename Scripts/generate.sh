#!/bin/bash
set -euo pipefail

OUTPUT_DIR_FEEDS="../StreamFeeds/Sources/StreamFeeds/generated/feeds"
CHAT_DIR="../chat"

rm -rf $OUTPUT_DIR_FEEDS

( cd $CHAT_DIR ; make openapi ; go run ./cmd/chat-manager openapi generate-client --language swift --spec ./releases/v2/feeds-clientside-api.yaml --output $OUTPUT_DIR_FEEDS )

mint run swiftformat --config .swiftformat Sources/StreamFeeds/generated/feeds/
