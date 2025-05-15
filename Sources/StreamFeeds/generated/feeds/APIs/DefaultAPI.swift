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

    open func addActivity(addActivityRequest: AddActivityRequest) async throws -> AddActivityResponse {
        let path = "/feeds/v3/activities"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: addActivityRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AddActivityResponse.self, from: $0)
        }
    }

    open func upsertActivities(createActivitiesBatchRequest: CreateActivitiesBatchRequest) async throws -> CreateActivitiesBatchResponse {
        let path = "/feeds/v3/activities/batch"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: createActivitiesBatchRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(CreateActivitiesBatchResponse.self, from: $0)
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

    open func deleteActivity(activityId: String, hardDelete: Bool?) async throws -> DeleteActivityResponse {
        var path = "/feeds/v3/activities/{activity_id}"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "hard_delete": (wrappedValue: hardDelete?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(DeleteActivityResponse.self, from: $0)
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

    open func deleteBookmark(activityId: String) async throws -> DeleteBookmarkResponse {
        var path = "/feeds/v3/activities/{activity_id}/bookmarks"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(DeleteBookmarkResponse.self, from: $0)
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

    open func addBookmark(activityId: String, addBookmarkRequest: AddBookmarkRequest) async throws -> AddBookmarkResponse {
        var path = "/feeds/v3/activities/{activity_id}/bookmarks"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: addBookmarkRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AddBookmarkResponse.self, from: $0)
        }
    }

    open func addComment(activityId: String, addCommentRequest: AddCommentRequest) async throws -> AddCommentResponse {
        var path = "/feeds/v3/activities/{activity_id}/comments"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: addCommentRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AddCommentResponse.self, from: $0)
        }
    }

    open func deleteActivityReaction(activityId: String) async throws -> DeleteActivityReactionResponse {
        var path = "/feeds/v3/activities/{activity_id}/reactions"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(DeleteActivityReactionResponse.self, from: $0)
        }
    }

    open func addReaction(activityId: String, addReactionRequest: AddReactionRequest) async throws -> AddReactionResponse {
        var path = "/feeds/v3/activities/{activity_id}/reactions"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: addReactionRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AddReactionResponse.self, from: $0)
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

    open func removeComment(commentId: String) async throws -> RemoveCommentResponse {
        var path = "/feeds/v3/comments/{comment_id}"

        let commentIdPreEscape = "\(APIHelper.mapValueToPathItem(commentId))"
        let commentIdPostEscape = commentIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "comment_id"), with: commentIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(RemoveCommentResponse.self, from: $0)
        }
    }

    open func updateComment(commentId: String, updateCommentRequest: UpdateCommentRequest) async throws -> UpdateCommentResponse {
        var path = "/feeds/v3/comments/{comment_id}"

        let commentIdPreEscape = "\(APIHelper.mapValueToPathItem(commentId))"
        let commentIdPostEscape = commentIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "comment_id"), with: commentIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PATCH",
            request: updateCommentRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpdateCommentResponse.self, from: $0)
        }
    }

    open func deleteFeed(feedGroupId: String, feedId: String, hardDelete: Bool?) async throws -> DeleteFeedResponse {
        var path = "/feeds/v3/feed_groups/{feed_group_id}/feeds/{feed_id}"

        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)
        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "hard_delete": (wrappedValue: hardDelete?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(DeleteFeedResponse.self, from: $0)
        }
    }

    open func updateFeed(feedGroupId: String, feedId: String, updateFeedRequest: UpdateFeedRequest) async throws -> UpdateFeedResponse {
        var path = "/feeds/v3/feed_groups/{feed_group_id}/feeds/{feed_id}"

        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)
        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PATCH",
            request: updateFeedRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpdateFeedResponse.self, from: $0)
        }
    }

    open func getOrCreateFeed(feedGroupId: String, feedId: String, getOrCreateFeedRequest: GetOrCreateFeedRequest) async throws -> GetOrCreateFeedResponse {
        var path = "/feeds/v3/feed_groups/{feed_group_id}/feeds/{feed_id}"

        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)
        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: getOrCreateFeedRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(GetOrCreateFeedResponse.self, from: $0)
        }
    }

    open func markActivity(feedGroupId: String, feedId: String, markActivityRequest: MarkActivityRequest) async throws -> Response {
        var path = "/feeds/v3/feed_groups/{feed_group_id}/feeds/{feed_id}/activities/mark/batch"

        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)
        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: markActivityRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(Response.self, from: $0)
        }
    }

    open func unpinActivity(feedGroupId: String, feedId: String, activityId: String) async throws -> UnpinActivityResponse {
        var path = "/feeds/v3/feed_groups/{feed_group_id}/feeds/{feed_id}/activities/{activity_id}/pin"

        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)
        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)
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

    open func pinActivity(feedGroupId: String, feedId: String, activityId: String) async throws -> PinActivityResponse {
        var path = "/feeds/v3/feed_groups/{feed_group_id}/feeds/{feed_id}/activities/{activity_id}/pin"

        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)
        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)
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

    open func updateFeedMembers(feedGroupId: String, feedId: String, updateFeedMembersRequest: UpdateFeedMembersRequest) async throws -> Response {
        var path = "/feeds/v3/feed_groups/{feed_group_id}/feeds/{feed_id}/members"

        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)
        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PATCH",
            request: updateFeedMembersRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(Response.self, from: $0)
        }
    }

    open func acceptFeedMember(feedId: String, feedGroupId: String, acceptFeedMemberRequest: AcceptFeedMemberRequest) async throws -> AcceptFeedMemberResponse {
        var path = "/feeds/v3/feed_groups/{feed_group_id}/feeds/{feed_id}/members/accept"

        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)
        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: acceptFeedMemberRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AcceptFeedMemberResponse.self, from: $0)
        }
    }

    open func queryFeedMembers(feedGroupId: String, feedId: String, queryFeedMembersRequest: QueryFeedMembersRequest) async throws -> QueryFeedMembersResponse {
        var path = "/feeds/v3/feed_groups/{feed_group_id}/feeds/{feed_id}/members/query"

        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)
        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: queryFeedMembersRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryFeedMembersResponse.self, from: $0)
        }
    }

    open func rejectFeedMember(feedGroupId: String, feedId: String, rejectFeedMemberRequest: RejectFeedMemberRequest) async throws -> RejectFeedMemberResponse {
        var path = "/feeds/v3/feed_groups/{feed_group_id}/feeds/{feed_id}/members/reject"

        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)
        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)

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
        let path = "/feeds/v3/feeds/batch"

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

    open func updateFollow(updateFollowRequest: UpdateFollowRequest) async throws -> UpdateFollowResponse {
        let path = "/feeds/v3/follows"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PATCH",
            request: updateFollowRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpdateFollowResponse.self, from: $0)
        }
    }

    open func follow(followRequest: FollowRequest) async throws -> FollowResponse {
        let path = "/feeds/v3/follows"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: followRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(FollowResponse.self, from: $0)
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

    open func followMany(followManyRequest: FollowManyRequest) async throws -> FollowManyResponse {
        let path = "/feeds/v3/follows/batch"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: followManyRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(FollowManyResponse.self, from: $0)
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
}

protocol DefaultAPIEndpoints {
    func addActivity(addActivityRequest: AddActivityRequest) async throws -> AddActivityResponse

    func upsertActivities(createActivitiesBatchRequest: CreateActivitiesBatchRequest) async throws -> CreateActivitiesBatchResponse

    func queryActivities(queryActivitiesRequest: QueryActivitiesRequest) async throws -> QueryActivitiesResponse

    func removeActivities(removeActivitiesRequest: RemoveActivitiesRequest) async throws -> RemoveActivitiesResponse

    func deleteActivity(activityId: String, hardDelete: Bool?) async throws -> DeleteActivityResponse

    func getActivity(activityId: String) async throws -> GetActivityResponse

    func updateActivityPartial(activityId: String, updateActivityPartialRequest: UpdateActivityPartialRequest) async throws -> UpdateActivityPartialResponse

    func deleteBookmark(activityId: String) async throws -> DeleteBookmarkResponse

    func updateBookmark(activityId: String, updateBookmarkRequest: UpdateBookmarkRequest) async throws -> UpdateBookmarkResponse

    func addBookmark(activityId: String, addBookmarkRequest: AddBookmarkRequest) async throws -> AddBookmarkResponse

    func addComment(activityId: String, addCommentRequest: AddCommentRequest) async throws -> AddCommentResponse

    func deleteActivityReaction(activityId: String) async throws -> DeleteActivityReactionResponse

    func addReaction(activityId: String, addReactionRequest: AddReactionRequest) async throws -> AddReactionResponse

    func queryComments(queryCommentsRequest: QueryCommentsRequest) async throws -> QueryCommentsResponse

    func removeComment(commentId: String) async throws -> RemoveCommentResponse

    func updateComment(commentId: String, updateCommentRequest: UpdateCommentRequest) async throws -> UpdateCommentResponse

    func deleteFeed(feedGroupId: String, feedId: String, hardDelete: Bool?) async throws -> DeleteFeedResponse

    func updateFeed(feedGroupId: String, feedId: String, updateFeedRequest: UpdateFeedRequest) async throws -> UpdateFeedResponse

    func getOrCreateFeed(feedGroupId: String, feedId: String, getOrCreateFeedRequest: GetOrCreateFeedRequest) async throws -> GetOrCreateFeedResponse

    func markActivity(feedGroupId: String, feedId: String, markActivityRequest: MarkActivityRequest) async throws -> Response

    func unpinActivity(feedGroupId: String, feedId: String, activityId: String) async throws -> UnpinActivityResponse

    func pinActivity(feedGroupId: String, feedId: String, activityId: String) async throws -> PinActivityResponse

    func updateFeedMembers(feedGroupId: String, feedId: String, updateFeedMembersRequest: UpdateFeedMembersRequest) async throws -> Response

    func acceptFeedMember(feedId: String, feedGroupId: String, acceptFeedMemberRequest: AcceptFeedMemberRequest) async throws -> AcceptFeedMemberResponse

    func queryFeedMembers(feedGroupId: String, feedId: String, queryFeedMembersRequest: QueryFeedMembersRequest) async throws -> QueryFeedMembersResponse

    func rejectFeedMember(feedGroupId: String, feedId: String, rejectFeedMemberRequest: RejectFeedMemberRequest) async throws -> RejectFeedMemberResponse

    func createManyFeeds(createManyFeedsRequest: CreateManyFeedsRequest) async throws -> CreateManyFeedsResponse

    func feedsQueryFeeds() async throws -> QueryFeedsResponse

    func getFollowSuggestions() async throws -> FollowSuggestionsResponse

    func updateFollow(updateFollowRequest: UpdateFollowRequest) async throws -> UpdateFollowResponse

    func follow(followRequest: FollowRequest) async throws -> FollowResponse

    func acceptFollow(acceptFollowRequest: AcceptFollowRequest) async throws -> AcceptFollowResponse

    func followMany(followManyRequest: FollowManyRequest) async throws -> FollowManyResponse

    func queryFollows(queryFollowsRequest: QueryFollowsRequest) async throws -> QueryFollowsResponse

    func rejectFollow(rejectFollowRequest: RejectFollowRequest) async throws -> RejectFollowResponse

    func unfollow(source: String, target: String) async throws -> UnfollowResponse
}
