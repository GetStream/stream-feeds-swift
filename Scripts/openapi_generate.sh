#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_DIR_FEEDS="$REPO_ROOT/Sources/StreamFeeds/generated/feeds"
CHAT_DIR="${CHAT_DIR:-$REPO_ROOT/../chat}"
ALLOWED_FILE="$SCRIPT_DIR/openapi-allowed.json"

source "$SCRIPT_DIR/openapi_generate_helpers.sh"

[ -d "$CHAT_DIR" ] || { echo "chat repo not found at $CHAT_DIR (set CHAT_DIR)" >&2; exit 1; }
command -v jq > /dev/null || { echo "jq not found (brew install jq)" >&2; exit 1; }

rm -rf "$OUTPUT_DIR_FEEDS"
( cd "$CHAT_DIR" ; make openapi ; make -C tools/openapi build ; \
  ./build/openapi generate-client --language swift \
    --opt number_as_float=true \
    --spec ./releases/v2/feeds-clientside-api.yaml --output "$OUTPUT_DIR_FEEDS" )

# Unused: the SDK calls DefaultAPI and decodes FeedsEvent.
rm -f "$OUTPUT_DIR_FEEDS/APIs/DefaultEndpoints.swift" "$OUTPUT_DIR_FEEDS/models/WSClientEvent.swift"

# Already defined by StreamCore or Sources/StreamFeeds.
for model in APIError ConnectUserDetailsRequest CreateDeviceRequest DeviceResponse ListDevicesResponse User; do
  rm -f "$OUTPUT_DIR_FEEDS/models/$model.swift"
done

# Keep the public FeedsEvent name for the WS event discriminator.
mv "$OUTPUT_DIR_FEEDS/models/WSEvent.swift" "$OUTPUT_DIR_FEEDS/models/FeedsEvent.swift"
sed -i '' 's/[[:<:]]WSEvent[[:>:]]/FeedsEvent/g' "$OUTPUT_DIR_FEEDS/models/FeedsEvent.swift"

remove_unused_endpoints

# Chat and video specific parts of the shared models.
perl -0pi -e 's/, channelCid: String\?\)( async throws -> UnbanResponse)/)$1/g; s/,\n\s*"channel_cid": \(wrappedValue: channelCid\?\.encodeToJSON\(\), isExplode: true\)//' \
  "$OUTPUT_DIR_FEEDS/APIs/DefaultAPI.swift"

remove_properties
remove_types

# CHA-6288: Moderation uses duplicate models for feeds data, backend has tests to keep them in sync.
sed -i '' -E 's/[[:<:]]FeedsV3(Activity|Comment)Response[[:>:]]/\1Response/g' \
  "$OUTPUT_DIR_FEEDS/models/ReviewQueueItemResponse.swift"

prune_unreachable_models FeedsEvent

swiftformat --config "$REPO_ROOT/.swiftformat" --unexclude "$OUTPUT_DIR_FEEDS" "$OUTPUT_DIR_FEEDS"

echo "Pruned unreachable models: $pruned_model_count"
echo "Ignored endpoints (${#pruned_endpoints[@]}):"
printf '  %s\n' ${pruned_endpoints[@]+"${pruned_endpoints[@]}"} | sort
