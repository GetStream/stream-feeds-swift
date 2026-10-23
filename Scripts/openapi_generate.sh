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
    longPoll # SDK uses WebSocket
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
    --opt immutable_models=true \
    --opt raw_representable_over_enum=true \
    --opt string_coding_keys=true \
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
remove_property OwnUserResponse channelMutes latestHiddenChannels totalUnreadCount totalUnreadCountByTeam unreadChannels \
  unreadCount unreadThreads
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

# IOS-2213: new properties on existing models, not exposed yet.
remove_property ActionLogResponse reporterType
remove_property ActivityRequest collectionRefs collections copyCustomToNotification \
  createNotificationActivity restrictReplies skipEnrichUrl skipPush
remove_property ActivityResponse collections friendReactionCount friendReactions i18n isRead isSeen \
  isWatched latestShares metrics moderationAction preview restrictReplies scoreVars selectorSource \
  topLevelCommentCount
remove_property AddActivityRequest collections copyCustomToNotification enrichOwnFields
remove_property AddActivityResponse skippedExisting
remove_property AddCommentReactionRequest copyCustomToNotification targetFeeds
remove_property AddCommentReactionResponse counterDelta notificationAccepted notificationCreated \
  notificationTaskId outcome previousReactionType referenceActivity
remove_property AddCommentRequest copyCustomToNotification id skipEnrichUrl
remove_property AddCommentResponse mentionNotificationsCreated notificationCreated
remove_property AddReactionRequest copyCustomToNotification targetFeeds
remove_property AddReactionResponse counterDelta notificationAccepted notificationCreated \
  notificationTaskId outcome previousReactionType referenceActivity
remove_property AggregatedActivityResponse isRead isSeen
remove_property AWSRekognitionRule subclassifications
remove_property BanInfoResponse user
remove_property BanRequest deleteReactions
remove_property BlockListConfig matchSubstring
remove_property BlockListResponse isConfusableFoldingEnabled isLeetCheckEnabled isPluralCheckEnabled \
  isSubstringMatchingEnabled ownerUserId
remove_property BookmarkFolderResponse user
remove_property BookmarkResponse activityId comment objectId objectType
remove_property CommentResponse bookmarkCount editedAt hidden i18n
remove_property ConfigResponse aiAudioConfig aiImageLabelDefinitions aiImageSubclassifications \
  floodConfig intentConfig
remove_property CreateBlockListRequest isConfusableFoldingEnabled isLeetCheckEnabled \
  isPluralCheckEnabled isSubstringMatchingEnabled
remove_property CreateFeedsBatchRequest enrichOwnFields
remove_property CreatePollRequest team
remove_property DeleteActivitiesRequest deleteNotificationActivity
remove_property DeleteActivityRequestPayload entityId entityType reason
remove_property DeleteReactionRequestPayload entityId entityType reason
remove_property EnrichedActivity time
remove_property EnrichedReaction createdAt updatedAt
remove_property FeedInput location
remove_property FeedRequest location
remove_property FeedResponse activityCount location ownFollowings
remove_property FeedsPreferences commentMention commentReply
remove_property FeedSuggestionResponse activityCount location ownFollowings
remove_property FollowBatchRequest enrichOwnFields
remove_property FollowBatchResponse created
remove_property FollowRequest activityCopyLimit copyCustomToNotification enrichOwnFields
remove_property GetCommentRepliesResponse sort
remove_property GetCommentsResponse commentCount sort topLevelCommentCount
remove_property GetFollowSuggestionsResponse algorithmUsed
remove_property GetOrCreateFeedRequest discardActors enrichmentOptions friendReactionsOptions \
  idAround overwriteInterestWeights viewerLocation
remove_property GetOrCreateFeedResponse degradedSelectors
remove_property HealthCheckEvent custom me
remove_property ImageContentParameters labelOperator minConfidence
remove_property ImageRuleParameters minConfidence
remove_property ListBlockListResponse nextCursor
remove_property LLMConfig contextCustomKeys customKeysContextDescription
remove_property MarkReviewedRequestPayload decisionReason
remove_property ModerationActionConfigResponse id queueType
remove_property ModerationFlaggedEvent contentType custom receivedAt
remove_property ModerationFlagResponse contentPublishedAt id
remove_property ModerationMarkReviewedEvent custom receivedAt
remove_property ModerationPayload audios countryCode imageIds imageOrderedKeys otherMedia textIds \
  textOrderedKeys
remove_property ModerationV2Response blocklistsMatched
remove_property NotificationTarget comment custom parentActivity
remove_property NotificationTrigger comment custom
remove_property OwnUserResponse avgResponseTime banned invisible mutes online privacySettings pushPreferences \
  teamsRole
remove_property PollOptionResponseData textI18n
remove_property PollResponseData descriptionI18n nameI18n
remove_property PollVoteResponse poll
remove_property PollVoteResponseData answerTextI18n
remove_property PrivacySettingsResponse deliveryReceipts typingIndicators
remove_property PushPreferenceInput removeSchedule schedule
remove_property PushPreferencesResponse schedule
remove_property QueryActivitiesRequest enrichOwnFields
remove_property QueryBookmarksRequest enrichOwnFields
remove_property QueryCommentsRequest idAround
remove_property QueryFeedsRequest enrichOwnFields
remove_property QueryFollowsResponse groupCounts
remove_property QueryReviewQueueRequest excludeDefaultActionConfig
remove_property QueryReviewQueueResponse defaultActionConfig filterConfig
remove_property QueryUsersPayload idGt idGte idLt idLte
remove_property ReviewQueueItemResponse appeal confidenceScore countryCode escalated escalatedAt \
  escalatedBy escalationMetadata falsePositiveFlags feedsV2Reaction feedsV3Activity feedsV3Comment \
  latestModeratorAction mediaDisplay poll reaction
remove_property RuleBuilderAction reason skipInbox
remove_property RuleBuilderCondition contentCountryCodeParams contentCustomPropertyCountParams \
  contentCustomPropertyParams contentFlagCountRuleParams floodIdenticalParams floodSimilarParams \
  intentRuleParams ipContentCountRuleParams ipFlagCountRuleParams ocrContentParams \
  userFlagCountRuleParams userIdenticalContentCountParams userIdenticalImageCountParams \
  userReactionCountParams userRoleParams
remove_property SingleFollowResponse notificationCreated
remove_property SortParamRequest type
remove_property SubmitActionRequest appealId block bypass deleteComment deletePoll deletePollAnswer \
  deletePollOption escalate flag rejectAppeal restore shadowBlock unblock
remove_property SubmitActionResponse appealItem autoRestoreWarning
remove_property TextContentParameters labelOperator textLength textLengthOperator
remove_property TextRuleParameters semanticFilterMinThreshold semanticFilterNames
remove_property ThreadedCommentResponse bookmarkCount editedAt hidden i18n
remove_property UpdateActivityPartialRequest copyCustomToNotification enrichOwnFields \
  handleMentionNotifications runActivityProcessors
remove_property UpdateActivityRequest collectionRefs copyCustomToNotification enrichOwnFields \
  handleMentionNotifications mentionedUserIds restrictReplies runActivityProcessors searchData \
  skipEnrichUrl visibilityTag
remove_property UpdateBlockListRequest isConfusableFoldingEnabled isLeetCheckEnabled \
  isPluralCheckEnabled isSubstringMatchingEnabled
remove_property UpdateCommentRequest attachments copyCustomToNotification handleMentionNotifications \
  mentionedUserIds skipEnrichUrl
remove_property UpdateFeedRequest clearLocation description enrichOwnFields filterTags location name
remove_property UpdateFollowRequest enrichOwnFields
remove_property UpsertActivitiesRequest enrichOwnFields
remove_property UpsertActivitiesResponse mentionNotificationsCreated skippedExisting
remove_property UpsertConfigRequest aiAudioConfig floodConfig intentConfig
remove_property UserBannedEvent custom receivedAt reviewQueueItemId
remove_property UserDeactivatedEvent custom receivedAt
remove_property UserReactivatedEvent createdBy custom receivedAt
remove_property VideoContentParameters labelOperator
remove_property WSAuthMessage eventProtocol memberCustomInclude

# CHA-6288: Moderation uses duplicate models for feeds data, backend has tests to keep them in sync.
sed -i '' -E 's/[[:<:]]FeedsV3(Activity|Comment)Response[[:>:]]/\1Response/g' \
  "$OUTPUT_DIR_FEEDS/models/ReviewQueueItemResponse.swift"

prune_unreachable_models FeedsEvent
prune_unused_string_coding_keys

swiftformat --config "$REPO_ROOT/.swiftformat" --unexclude "$OUTPUT_DIR_FEEDS" "$OUTPUT_DIR_FEEDS"

echo "Pruned unreachable models: $pruned_model_count"
echo "Ignored endpoints (${#pruned_endpoints[@]}):"
printf '  %s\n' ${pruned_endpoints[@]+"${pruned_endpoints[@]}"} | sort
