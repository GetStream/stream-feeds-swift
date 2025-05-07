import Foundation
import StreamCore

open class DefaultAPI: DefaultAPIEndpoints, @unchecked Sendable {
    var transport: DefaultAPITransport
    var middlewares: [DefaultAPIClientMiddleware]
    var basePath: String
    var jsonDecoder: JSONDecoder
    var jsonEncoder: JSONEncoder

    init(
        basePath: String,
        transport: DefaultAPITransport,
        middlewares: [DefaultAPIClientMiddleware],
        jsonDecoder: JSONDecoder = JSONDecoder.default,
        jsonEncoder: JSONEncoder = JSONEncoder.default
    ) {
        self.basePath = basePath
        self.transport = transport
        self.middlewares = middlewares
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
    }

    func send<Response: Codable>(
        request: Request,
        deserializer: (Data) throws -> Response
    ) async throws -> Response {
        // TODO: make this a bit nicer and create an API error to make it easier to handle stuff
        func makeError(_ error: Error) -> Error {
            return error
        }

        func wrappingErrors<R>(
            work: () async throws -> R,
            mapError: (Error) -> Error
        ) async throws -> R {
            do {
                return try await work()
            } catch {
                throw mapError(error)
            }
        }

        let (data, _) = try await wrappingErrors {
            var next: (Request) async throws -> (Data, URLResponse) = { _request in
                try await wrappingErrors {
                    try await self.transport.execute(request: _request)
                } mapError: { error in
                    makeError(error)
                }
            }
            for middleware in middlewares.reversed() {
                let tmp = next
                next = {
                    try await middleware.intercept(
                        $0,
                        next: tmp
                    )
                }
            }
            return try await next(request)
        } mapError: { error in
            makeError(error)
        }

        return try await wrappingErrors {
            try deserializer(data)
        } mapError: { error in
            makeError(error)
        }
    }

    func makeRequest(
        uriPath: String,
        queryParams: [URLQueryItem] = [],
        httpMethod: String
    ) throws -> Request {
        let url = URL(string: basePath + uriPath)!
        return Request(
            url: url,
            method: .init(stringValue: httpMethod),
            queryParams: queryParams,
            headers: ["Content-Type": "application/json"]
        )
    }

    func makeRequest<T: Encodable>(
        uriPath: String,
        queryParams: [URLQueryItem] = [],
        httpMethod: String,
        request: T
    ) throws -> Request {
        var r = try makeRequest(uriPath: uriPath, queryParams: queryParams, httpMethod: httpMethod)
        r.body = try jsonEncoder.encode(request)
        return r
    }

    open func upsertActivities(upsertActivitiesRequest: UpsertActivitiesRequest) async throws -> UpsertActivitiesResponse {
        let path = "/feeds/v3/activities"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: upsertActivitiesRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpsertActivitiesResponse.self, from: $0)
        }
    }

    open func queryActivities(queryActivitiesRequest: QueryActivitiesRequest) async throws -> QueryActivitiesResponse {
        let path = "/feeds/v3/activities/query"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: queryActivitiesRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryActivitiesResponse.self, from: $0)
        }
    }

    open func removeActivities(removeActivitiesRequest: RemoveActivitiesRequest) async throws -> RemoveActivitiesResponse {
        let path = "/feeds/v3/activities/remove"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: removeActivitiesRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(RemoveActivitiesResponse.self, from: $0)
        }
    }

    open func removeActivity(activityId: String) async throws -> RemoveActivityResponse {
        var path = "/feeds/v3/activities/{activity_id}"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(RemoveActivityResponse.self, from: $0)
        }
    }

    open func getActivity(activityId: String) async throws -> GetActivityResponse {
        var path = "/feeds/v3/activities/{activity_id}"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(GetActivityResponse.self, from: $0)
        }
    }

    open func updateActivityPartial(activityId: String, updateActivityPartialRequest: UpdateActivityPartialRequest) async throws -> UpdateActivityPartialResponse {
        var path = "/feeds/v3/activities/{activity_id}"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PATCH",
            request: updateActivityPartialRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpdateActivityPartialResponse.self, from: $0)
        }
    }

    open func removeBookmark(activityId: String) async throws -> RemoveBookmarkResponse {
        var path = "/feeds/v3/activities/{activity_id}/bookmarks"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(RemoveBookmarkResponse.self, from: $0)
        }
    }

    open func updateBookmark(activityId: String, updateBookmarkRequest: UpdateBookmarkRequest) async throws -> UpdateBookmarkResponse {
        var path = "/feeds/v3/activities/{activity_id}/bookmarks"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PATCH",
            request: updateBookmarkRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpdateBookmarkResponse.self, from: $0)
        }
    }

    open func addBookmark(addBookmarkRequest: AddBookmarkRequest) async throws -> AddBookmarkResponse {
        let path = "/feeds/v3/activities/{activity_id}/bookmarks"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: addBookmarkRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AddBookmarkResponse.self, from: $0)
        }
    }

    open func addActivity(addActivityRequest: AddActivityRequest) async throws -> AddActivityResponse {
        let path = "/feeds/v3/activity"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: addActivityRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AddActivityResponse.self, from: $0)
        }
    }

    open func removeComment() async throws -> RemoveCommentResponse {
        let path = "/feeds/v3/comments"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(RemoveCommentResponse.self, from: $0)
        }
    }

    open func addComment(addCommentRequest: AddCommentRequest) async throws -> AddCommentResponse {
        let path = "/feeds/v3/comments"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: addCommentRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AddCommentResponse.self, from: $0)
        }
    }

    open func updateComment(updateCommentRequest: UpdateCommentRequest) async throws -> UpdateCommentResponse {
        let path = "/feeds/v3/comments"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PUT",
            request: updateCommentRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpdateCommentResponse.self, from: $0)
        }
    }

    open func queryComments(queryCommentsRequest: QueryCommentsRequest) async throws -> QueryCommentsResponse {
        let path = "/feeds/v3/comments/query"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: queryCommentsRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryCommentsResponse.self, from: $0)
        }
    }

    open func createFeed(createFeedRequest: CreateFeedRequest) async throws -> CreateFeedResponse {
        let path = "/feeds/v3/feed"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: createFeedRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(CreateFeedResponse.self, from: $0)
        }
    }

    open func acceptFeedMember(acceptFeedMemberRequest: AcceptFeedMemberRequest) async throws -> AcceptFeedMemberResponse {
        let path = "/feeds/v3/feed_members/accept"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: acceptFeedMemberRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AcceptFeedMemberResponse.self, from: $0)
        }
    }

    open func rejectFeedMember(rejectFeedMemberRequest: RejectFeedMemberRequest) async throws -> RejectFeedMemberResponse {
        let path = "/feeds/v3/feed_members/reject"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: rejectFeedMemberRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(RejectFeedMemberResponse.self, from: $0)
        }
    }

    open func createManyFeeds(createManyFeedsRequest: CreateManyFeedsRequest) async throws -> CreateManyFeedsResponse {
        let path = "/feeds/v3/feeds"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: createManyFeedsRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(CreateManyFeedsResponse.self, from: $0)
        }
    }

    open func feedsQueryFeeds() async throws -> QueryFeedsResponse {
        let path = "/feeds/v3/feeds/query"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryFeedsResponse.self, from: $0)
        }
    }

    open func removeFeed() async throws -> RemoveFeedResponse {
        let path = "/feeds/v3/feeds/{feed_group}/{feed_id}"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(RemoveFeedResponse.self, from: $0)
        }
    }

    open func getFeed(feedId: String) async throws -> GetFeedResponse {
        var path = "/feeds/v3/feeds/{feed_group}/{feed_id}"

        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(GetFeedResponse.self, from: $0)
        }
    }

    open func markActivity(markActivityRequest: MarkActivityRequest) async throws -> Response {
        let path = "/feeds/v3/feeds/{feed_group}/{feed_id}/mark_activity"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: markActivityRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(Response.self, from: $0)
        }
    }

    open func updateFeedMembers(feedGroup: String, feedId: String, updateFeedMembersRequest: UpdateFeedMembersRequest) async throws -> Response {
        var path = "/feeds/v3/feeds/{feed_group}/{feed_id}/members"

        let feedGroupPreEscape = "\(APIHelper.mapValueToPathItem(feedGroup))"
        let feedGroupPostEscape = feedGroupPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group"), with: feedGroupPostEscape, options: .literal, range: nil)
        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: updateFeedMembersRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(Response.self, from: $0)
        }
    }

    open func unpinActivity(activityId: String) async throws -> UnpinActivityResponse {
        var path = "/feeds/v3/feeds/{feed_group}/{feed_id}/pin_activity/{activity_id}"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UnpinActivityResponse.self, from: $0)
        }
    }

    open func pinActivity(activityId: String) async throws -> PinActivityResponse {
        var path = "/feeds/v3/feeds/{feed_group}/{feed_id}/pin_activity/{activity_id}"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(PinActivityResponse.self, from: $0)
        }
    }

    open func follow(followRequest: FollowRequest) async throws -> FollowResponse {
        let path = "/feeds/v3/follow"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: followRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(FollowResponse.self, from: $0)
        }
    }

    open func getFollowSuggestions() async throws -> FollowSuggestionsResponse {
        let path = "/feeds/v3/follow_suggestions"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(FollowSuggestionsResponse.self, from: $0)
        }
    }

    open func followMany(followManyRequest: FollowManyRequest) async throws -> FollowManyResponse {
        let path = "/feeds/v3/follows"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: followManyRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(FollowManyResponse.self, from: $0)
        }
    }

    open func acceptFollow(acceptFollowRequest: AcceptFollowRequest) async throws -> AcceptFollowResponse {
        let path = "/feeds/v3/follows/accept"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: acceptFollowRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AcceptFollowResponse.self, from: $0)
        }
    }

    open func queryFollows(queryFollowsRequest: QueryFollowsRequest) async throws -> QueryFollowsResponse {
        let path = "/feeds/v3/follows/query"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: queryFollowsRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryFollowsResponse.self, from: $0)
        }
    }

    open func rejectFollow(rejectFollowRequest: RejectFollowRequest) async throws -> RejectFollowResponse {
        let path = "/feeds/v3/follows/reject"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: rejectFollowRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(RejectFollowResponse.self, from: $0)
        }
    }

    open func updateFollow(updateFollowRequest: UpdateFollowRequest) async throws -> UpdateFollowResponse {
        let path = "/feeds/v3/follows/{id}"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PUT",
            request: updateFollowRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpdateFollowResponse.self, from: $0)
        }
    }

    open func unfollow(source: String, target: String) async throws -> UnfollowResponse {
        var path = "/feeds/v3/follows/{source}/{target}"

        let sourcePreEscape = "\(APIHelper.mapValueToPathItem(source))"
        let sourcePostEscape = sourcePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "source"), with: sourcePostEscape, options: .literal, range: nil)
        let targetPreEscape = "\(APIHelper.mapValueToPathItem(target))"
        let targetPostEscape = targetPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "target"), with: targetPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UnfollowResponse.self, from: $0)
        }
    }

    open func removeActivityReaction() async throws -> RemoveActivityReactionResponse {
        let path = "/feeds/v3/reactions"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(RemoveActivityReactionResponse.self, from: $0)
        }
    }

    open func addReaction(addReactionRequest: AddReactionRequest) async throws -> AddReactionResponse {
        let path = "/feeds/v3/reactions"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: addReactionRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AddReactionResponse.self, from: $0)
        }
    }
}

protocol DefaultAPIEndpoints {
    func upsertActivities(upsertActivitiesRequest: UpsertActivitiesRequest) async throws -> UpsertActivitiesResponse

    func queryActivities(queryActivitiesRequest: QueryActivitiesRequest) async throws -> QueryActivitiesResponse

    func removeActivities(removeActivitiesRequest: RemoveActivitiesRequest) async throws -> RemoveActivitiesResponse

    func removeActivity(activityId: String) async throws -> RemoveActivityResponse

    func getActivity(activityId: String) async throws -> GetActivityResponse

    func updateActivityPartial(activityId: String, updateActivityPartialRequest: UpdateActivityPartialRequest) async throws -> UpdateActivityPartialResponse

    func removeBookmark(activityId: String) async throws -> RemoveBookmarkResponse

    func updateBookmark(activityId: String, updateBookmarkRequest: UpdateBookmarkRequest) async throws -> UpdateBookmarkResponse

    func addBookmark(addBookmarkRequest: AddBookmarkRequest) async throws -> AddBookmarkResponse

    func addActivity(addActivityRequest: AddActivityRequest) async throws -> AddActivityResponse

    func removeComment() async throws -> RemoveCommentResponse

    func addComment(addCommentRequest: AddCommentRequest) async throws -> AddCommentResponse

    func updateComment(updateCommentRequest: UpdateCommentRequest) async throws -> UpdateCommentResponse

    func queryComments(queryCommentsRequest: QueryCommentsRequest) async throws -> QueryCommentsResponse

    func createFeed(createFeedRequest: CreateFeedRequest) async throws -> CreateFeedResponse

    func acceptFeedMember(acceptFeedMemberRequest: AcceptFeedMemberRequest) async throws -> AcceptFeedMemberResponse

    func rejectFeedMember(rejectFeedMemberRequest: RejectFeedMemberRequest) async throws -> RejectFeedMemberResponse

    func createManyFeeds(createManyFeedsRequest: CreateManyFeedsRequest) async throws -> CreateManyFeedsResponse

    func feedsQueryFeeds() async throws -> QueryFeedsResponse

    func removeFeed() async throws -> RemoveFeedResponse

    func getFeed(feedId: String) async throws -> GetFeedResponse

    func markActivity(markActivityRequest: MarkActivityRequest) async throws -> Response

    func updateFeedMembers(feedGroup: String, feedId: String, updateFeedMembersRequest: UpdateFeedMembersRequest) async throws -> Response

    func unpinActivity(activityId: String) async throws -> UnpinActivityResponse

    func pinActivity(activityId: String) async throws -> PinActivityResponse

    func follow(followRequest: FollowRequest) async throws -> FollowResponse

    func getFollowSuggestions() async throws -> FollowSuggestionsResponse

    func followMany(followManyRequest: FollowManyRequest) async throws -> FollowManyResponse

    func acceptFollow(acceptFollowRequest: AcceptFollowRequest) async throws -> AcceptFollowResponse

    func queryFollows(queryFollowsRequest: QueryFollowsRequest) async throws -> QueryFollowsResponse

    func rejectFollow(rejectFollowRequest: RejectFollowRequest) async throws -> RejectFollowResponse

    func updateFollow(updateFollowRequest: UpdateFollowRequest) async throws -> UpdateFollowResponse

    func unfollow(source: String, target: String) async throws -> UnfollowResponse

    func removeActivityReaction() async throws -> RemoveActivityReactionResponse

    func addReaction(addReactionRequest: AddReactionRequest) async throws -> AddReactionResponse
}
