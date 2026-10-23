#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_DIR_FEEDS="$REPO_ROOT/Sources/StreamFeeds/generated/feeds"
CHAT_DIR="${CHAT_DIR:-$REPO_ROOT/../chat}"

source "$SCRIPT_DIR/openapi_generate_helpers.sh"

# DefaultAPI endpoints which are not exposed. Models used only by these are pruned as well.
ignored_endpoints=(
    addCommentBookmark
    addUserGroupMembers
    appeal
    batchQueryActivityReactions
    batchQueryCommentReactions
    bulkActionAppeals
    bulkDeleteActionConfig # CHA-6290 server-side only
    bulkUpsertActionConfig # CHA-6290 server-side only
    changeFeedVisibility
    commentFeedback
    createCollections
    createQueue
    createUserGroup
    deleteActionConfig # CHA-6290 server-side only
    deleteCollections
    deleteCommentBookmark
    deleteQueue
    deleteUserGroup
    deleteUserInterests
    getActionConfig # CHA-6290 server-side only
    getAppeal
    getFeedCounts
    getOrCreateFollow
    getOrCreateFollows
    getOrCreateUnfollow
    getOrCreateUnfollows
    getQueue
    getUserGroup
    getUserInterests
    getUserLiveLocations # Chat only
    listQueues
    listUserGroups
    queryActivityShares
    queryAppeals
    queryCollections
    queryPinnedActivities
    readCollections
    removeUserGroupMembers
    restoreActivity
    restoreComment
    revealMedia
    searchRoles
    searchUserGroups
    trackActivityMetrics
    translateActivity
    translateComment
    unban # CHA-6290 server-side only
    unmute
    updateCollections
    updateCommentBookmark
    updateCommentPartial
    updateLiveLocation # Chat only
    updateQueue
    updateUserGroup
    upsertActionConfig # CHA-6290 server-side only
    upsertUserInterests
)

[ -d "$CHAT_DIR" ] || { echo "chat repo not found at $CHAT_DIR (set CHAT_DIR)" >&2; exit 1; }

rm -rf "$OUTPUT_DIR_FEEDS"
( cd "$CHAT_DIR" ; make openapi ; make -C tools/openapi build ; \
  ./build/openapi generate-client --language swift \
    --opt number_as_float=true \
    --spec ./releases/v2/feeds-clientside-api.yaml --output "$OUTPUT_DIR_FEEDS" )

# Unused: the SDK calls DefaultAPI and decodes FeedsEvent.
rm -f "$OUTPUT_DIR_FEEDS/APIs/DefaultEndpoints.swift" "$OUTPUT_DIR_FEEDS/models/WSClientEvent.swift"

# Already defined by StreamCore or Sources/StreamFeeds.
for model in ConnectUserDetailsRequest ConnectedEvent ConnectionErrorEvent CreateDeviceRequest DeviceResponse HealthCheckEvent ListDevicesResponse OwnUserResponse User; do
  rm -f "$OUTPUT_DIR_FEEDS/models/$model.swift"
done

# Keep the public FeedsEvent name for the WS event discriminator.
mv "$OUTPUT_DIR_FEEDS/models/WSEvent.swift" "$OUTPUT_DIR_FEEDS/models/FeedsEvent.swift"
sed -i '' 's/[[:<:]]WSEvent[[:>:]]/FeedsEvent/g' "$OUTPUT_DIR_FEEDS/models/FeedsEvent.swift"

remove_endpoint "${ignored_endpoints[@]}"

# Chat and video specific parts of the shared models.
perl -0pi -e 's/, channelCid: String\?\)( async throws -> UnbanResponse)/)$1/g; s/,\n\s*"channel_cid": \(wrappedValue: channelCid\?\.encodeToJSON\(\), isExplode: true\)//' \
  "$OUTPUT_DIR_FEEDS/APIs/DefaultAPI.swift"

remove_property AppealItemResponse channelCid
remove_property AppealRequest channelCid
remove_property BanActionRequestPayload banFromFutureChannels channelBanOnly channelCid deleteMessages
remove_property BanInfoResponse channel channelCid
remove_property BanOptions deleteMessages
remove_property BanRequest banFromFutureChannels channelCid deleteMessages
remove_property ConfigResponse supportedVideoCallHarmTypes videoCallRuleConfig
remove_property DeleteUserRequestPayload deleteConversationChannels markMessagesDeleted
remove_property FullUserResponse channelMutes latestHiddenChannels totalUnreadCount unreadChannels unreadCount unreadThreads
remove_property ModerationCustomActionEvent message
remove_property ModerationMarkReviewedEvent message
remove_property PushPreferenceInput callLevel channelCid chatLevel chatPreferences
remove_property PushPreferencesResponse callLevel chatLevel chatPreferences
remove_property ReviewQueueItemResponse call message
remove_property RuleBuilderAction callOptions
remove_property RuleBuilderCondition callCustomPropertyParams callTypeRuleParams callViolationCountParams \
  channelMessageCountRuleParams closedCaptionRuleParams keyframeOcrRuleParams keyframeRuleParams \
  userChannelBanCountParams userChannelCountParams
remove_property RuleBuilderRule actionSequences
remove_property SubmitActionRequest deleteMessage deleteUserMessages
remove_property UnbanActionRequestPayload channelCid removeFutureChannelsBan
remove_property UpsertConfigRequest videoCallRuleConfig
remove_property UpsertPushPreferencesResponse userChannelPreferences
remove_property UserBannedEvent channelCustom channelId channelMemberCount channelMessageCount channelType cid
remove_property UserDeletedEvent deleteConversationChannels deleteMessages markMessagesDeleted
remove_property UserUnbannedEvent channelCustom channelId channelMemberCount channelMessageCount channelType cid
remove_property VelocityFilterConfig cidsPerUser

remove_type BanActionRequestPayload BanActionRequestPayloadDeleteMessages
remove_type BanOptions BanOptionsDeleteMessages
remove_type BanRequest BanRequestDeleteMessages
remove_type PushPreferenceInput PushPreferenceInputCallLevel
remove_type PushPreferenceInput PushPreferenceInputChatLevel

# CHA-6291: server-side only properties.
remove_property AcceptFollowRequest followerRole
remove_property AIAudioConfigRequest profile
remove_property AIAudioConfigResponse profile
remove_property AITextConfig profile
remove_property AppResponseFields id placement
remove_property ConfigResponse availableBodyguardProfiles
remove_property FeedGroupChangedEvent feedGroup
remove_property FeedMemberRequest membershipLevel role
remove_property FeedRequest createdById
remove_property FlagRequest entityCreatorId
remove_property FullUserResponse shadowBanned
remove_property QueryFollowsRequest includeGroupCounts
remove_property SubmitActionRequest ban deleteUser unban
remove_property UpdateFollowRequest activityCopyLimit copyCustomToNotification createNotificationActivity followerRole skipPush
remove_property UserBannedEvent totalBans
remove_property VelocityFilterConfig cascadingActions firstMessageOnly

# CHA-6288: Moderation uses duplicate models for feeds data, backend has tests to keep them in sync.
sed -i '' -E 's/[[:<:]]FeedsV3(Activity|Comment)Response[[:>:]]/\1Response/g' \
  "$OUTPUT_DIR_FEEDS/models/ReviewQueueItemResponse.swift"

# APIError is referenced only by handwritten code.
prune_unreachable_models APIError FeedsEvent

swiftformat --config "$REPO_ROOT/.swiftformat" --unexclude "$OUTPUT_DIR_FEEDS" "$OUTPUT_DIR_FEEDS"

swiftformat "$OUTPUT_DIR_FEEDS" \
  --unexclude "$OUTPUT_DIR_FEEDS" \
  --rules wrapArguments \
  --wrapparameters before-first \
  --wraparguments preserve \
  --maxwidth 100

echo "Pruned unreachable models: $pruned_model_count"
echo "Ignored endpoints (${#pruned_endpoints[@]}):"
printf '  %s\n' ${pruned_endpoints[@]+"${pruned_endpoints[@]}"} | sort
