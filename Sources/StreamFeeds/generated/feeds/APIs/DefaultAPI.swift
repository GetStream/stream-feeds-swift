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

    open func getApp() async throws -> GetApplicationResponse {
        let path = "/api/v2/app"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(GetApplicationResponse.self, from: $0)
        }
    }

    open func listBlockLists(team: String?) async throws -> ListBlockListResponse {
        let path = "/api/v2/blocklists"

        let queryParams = APIHelper.mapValuesToQueryItems([
            "team": (wrappedValue: team?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(ListBlockListResponse.self, from: $0)
        }
    }

    open func createBlockList(createBlockListRequest: CreateBlockListRequest) async throws -> CreateBlockListResponse {
        let path = "/api/v2/blocklists"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: createBlockListRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(CreateBlockListResponse.self, from: $0)
        }
    }

    open func deleteBlockList(name: String, team: String?) async throws -> Response {
        var path = "/api/v2/blocklists/{name}"

        let namePreEscape = "\(APIHelper.mapValueToPathItem(name))"
        let namePostEscape = namePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "name"), with: namePostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "team": (wrappedValue: team?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(Response.self, from: $0)
        }
    }

    open func updateBlockList(name: String, updateBlockListRequest: UpdateBlockListRequest) async throws -> UpdateBlockListResponse {
        var path = "/api/v2/blocklists/{name}"

        let namePreEscape = "\(APIHelper.mapValueToPathItem(name))"
        let namePostEscape = namePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "name"), with: namePostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PUT",
            request: updateBlockListRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpdateBlockListResponse.self, from: $0)
        }
    }

    open func deleteDevice(id: String) async throws -> Response {
        let path = "/api/v2/devices"

        let queryParams = APIHelper.mapValuesToQueryItems([
            "id": (wrappedValue: id.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(Response.self, from: $0)
        }
    }

    open func listDevices() async throws -> ListDevicesResponse {
        let path = "/api/v2/devices"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(ListDevicesResponse.self, from: $0)
        }
    }

    open func createDevice(createDeviceRequest: CreateDeviceRequest) async throws -> Response {
        let path = "/api/v2/devices"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: createDeviceRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(Response.self, from: $0)
        }
    }

    open func addActivity(addActivityRequest: AddActivityRequest) async throws -> AddActivityResponse {
        let path = "/api/v2/feeds/activities"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: addActivityRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AddActivityResponse.self, from: $0)
        }
    }

    open func upsertActivities(upsertActivitiesRequest: UpsertActivitiesRequest) async throws -> UpsertActivitiesResponse {
        let path = "/api/v2/feeds/activities/batch"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: upsertActivitiesRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpsertActivitiesResponse.self, from: $0)
        }
    }

    open func removeActivities(deleteActivitiesRequest: DeleteActivitiesRequest) async throws -> DeleteActivitiesResponse {
        let path = "/api/v2/feeds/activities/delete"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: deleteActivitiesRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(DeleteActivitiesResponse.self, from: $0)
        }
    }

    open func queryActivities(queryActivitiesRequest: QueryActivitiesRequest) async throws -> QueryActivitiesResponse {
        let path = "/api/v2/feeds/activities/query"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: queryActivitiesRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryActivitiesResponse.self, from: $0)
        }
    }

    open func deleteActivity(activityId: String, hardDelete: Bool?) async throws -> DeleteActivityResponse {
        var path = "/api/v2/feeds/activities/{activity_id}"

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
        var path = "/api/v2/feeds/activities/{activity_id}"

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
        var path = "/api/v2/feeds/activities/{activity_id}"

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

    open func updateActivity(activityId: String, updateActivityRequest: UpdateActivityRequest) async throws -> UpdateActivityResponse {
        var path = "/api/v2/feeds/activities/{activity_id}"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PUT",
            request: updateActivityRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpdateActivityResponse.self, from: $0)
        }
    }

    open func deleteBookmark(activityId: String, folderId: String?) async throws -> DeleteBookmarkResponse {
        var path = "/api/v2/feeds/activities/{activity_id}/bookmarks"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "folder_id": (wrappedValue: folderId?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(DeleteBookmarkResponse.self, from: $0)
        }
    }

    open func updateBookmark(activityId: String, updateBookmarkRequest: UpdateBookmarkRequest) async throws -> UpdateBookmarkResponse {
        var path = "/api/v2/feeds/activities/{activity_id}/bookmarks"

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
        var path = "/api/v2/feeds/activities/{activity_id}/bookmarks"

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

    open func castPollVote(activityId: String, pollId: String, castPollVoteRequest: CastPollVoteRequest) async throws -> PollVoteResponse {
        var path = "/api/v2/feeds/activities/{activity_id}/polls/{poll_id}/vote"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)
        let pollIdPreEscape = "\(APIHelper.mapValueToPathItem(pollId))"
        let pollIdPostEscape = pollIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "poll_id"), with: pollIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: castPollVoteRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(PollVoteResponse.self, from: $0)
        }
    }

    open func removePollVote(activityId: String, pollId: String, voteId: String, userId: String?) async throws -> PollVoteResponse {
        var path = "/api/v2/feeds/activities/{activity_id}/polls/{poll_id}/vote/{vote_id}"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)
        let pollIdPreEscape = "\(APIHelper.mapValueToPathItem(pollId))"
        let pollIdPostEscape = pollIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "poll_id"), with: pollIdPostEscape, options: .literal, range: nil)
        let voteIdPreEscape = "\(APIHelper.mapValueToPathItem(voteId))"
        let voteIdPostEscape = voteIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "vote_id"), with: voteIdPostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "user_id": (wrappedValue: userId?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(PollVoteResponse.self, from: $0)
        }
    }

    open func addReaction(activityId: String, addReactionRequest: AddReactionRequest) async throws -> AddReactionResponse {
        var path = "/api/v2/feeds/activities/{activity_id}/reactions"

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

    open func queryActivityReactions(activityId: String, queryActivityReactionsRequest: QueryActivityReactionsRequest) async throws -> QueryActivityReactionsResponse {
        var path = "/api/v2/feeds/activities/{activity_id}/reactions/query"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: queryActivityReactionsRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryActivityReactionsResponse.self, from: $0)
        }
    }

    open func deleteActivityReaction(activityId: String, type: String) async throws -> DeleteActivityReactionResponse {
        var path = "/api/v2/feeds/activities/{activity_id}/reactions/{type}"

        let activityIdPreEscape = "\(APIHelper.mapValueToPathItem(activityId))"
        let activityIdPostEscape = activityIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "activity_id"), with: activityIdPostEscape, options: .literal, range: nil)
        let typePreEscape = "\(APIHelper.mapValueToPathItem(type))"
        let typePostEscape = typePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "type"), with: typePostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(DeleteActivityReactionResponse.self, from: $0)
        }
    }

    open func queryBookmarkFolders(queryBookmarkFoldersRequest: QueryBookmarkFoldersRequest) async throws -> QueryBookmarkFoldersResponse {
        let path = "/api/v2/feeds/bookmark_folders/query"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: queryBookmarkFoldersRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryBookmarkFoldersResponse.self, from: $0)
        }
    }

    open func queryBookmarks(queryBookmarksRequest: QueryBookmarksRequest) async throws -> QueryBookmarksResponse {
        let path = "/api/v2/feeds/bookmarks/query"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: queryBookmarksRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryBookmarksResponse.self, from: $0)
        }
    }

    open func getComments(objectId: String, objectType: String, depth: Int?, sort: String?, repliesLimit: Int?, limit: Int?, prev: String?, next: String?) async throws -> GetCommentsResponse {
        let path = "/api/v2/feeds/comments"

        let queryParams = APIHelper.mapValuesToQueryItems([
            "object_id": (wrappedValue: objectId.encodeToJSON(), isExplode: true),
            "object_type": (wrappedValue: objectType.encodeToJSON(), isExplode: true),
            "depth": (wrappedValue: depth?.encodeToJSON(), isExplode: true),
            "sort": (wrappedValue: sort?.encodeToJSON(), isExplode: true),
            "replies_limit": (wrappedValue: repliesLimit?.encodeToJSON(), isExplode: true),
            "limit": (wrappedValue: limit?.encodeToJSON(), isExplode: true),
            "prev": (wrappedValue: prev?.encodeToJSON(), isExplode: true),
            "next": (wrappedValue: next?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(GetCommentsResponse.self, from: $0)
        }
    }

    open func addComment(addCommentRequest: AddCommentRequest) async throws -> AddCommentResponse {
        let path = "/api/v2/feeds/comments"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: addCommentRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AddCommentResponse.self, from: $0)
        }
    }

    open func addCommentsBatch(addCommentsBatchRequest: AddCommentsBatchRequest) async throws -> AddCommentsBatchResponse {
        let path = "/api/v2/feeds/comments/batch"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: addCommentsBatchRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AddCommentsBatchResponse.self, from: $0)
        }
    }

    open func queryComments(queryCommentsRequest: QueryCommentsRequest) async throws -> QueryCommentsResponse {
        let path = "/api/v2/feeds/comments/query"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: queryCommentsRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryCommentsResponse.self, from: $0)
        }
    }

    open func deleteComment(commentId: String) async throws -> DeleteCommentResponse {
        var path = "/api/v2/feeds/comments/{comment_id}"

        let commentIdPreEscape = "\(APIHelper.mapValueToPathItem(commentId))"
        let commentIdPostEscape = commentIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "comment_id"), with: commentIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(DeleteCommentResponse.self, from: $0)
        }
    }

    open func getComment(commentId: String) async throws -> GetCommentResponse {
        var path = "/api/v2/feeds/comments/{comment_id}"

        let commentIdPreEscape = "\(APIHelper.mapValueToPathItem(commentId))"
        let commentIdPostEscape = commentIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "comment_id"), with: commentIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(GetCommentResponse.self, from: $0)
        }
    }

    open func updateComment(commentId: String, updateCommentRequest: UpdateCommentRequest) async throws -> UpdateCommentResponse {
        var path = "/api/v2/feeds/comments/{comment_id}"

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

    open func addCommentReaction(commentId: String, addCommentReactionRequest: AddCommentReactionRequest) async throws -> AddCommentReactionResponse {
        var path = "/api/v2/feeds/comments/{comment_id}/reactions"

        let commentIdPreEscape = "\(APIHelper.mapValueToPathItem(commentId))"
        let commentIdPostEscape = commentIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "comment_id"), with: commentIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: addCommentReactionRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AddCommentReactionResponse.self, from: $0)
        }
    }

    open func queryCommentReactions(commentId: String, queryCommentReactionsRequest: QueryCommentReactionsRequest) async throws -> QueryCommentReactionsResponse {
        var path = "/api/v2/feeds/comments/{comment_id}/reactions/query"

        let commentIdPreEscape = "\(APIHelper.mapValueToPathItem(commentId))"
        let commentIdPostEscape = commentIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "comment_id"), with: commentIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: queryCommentReactionsRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryCommentReactionsResponse.self, from: $0)
        }
    }

    open func deleteCommentReaction(commentId: String, type: String) async throws -> DeleteCommentReactionResponse {
        var path = "/api/v2/feeds/comments/{comment_id}/reactions/{type}"

        let commentIdPreEscape = "\(APIHelper.mapValueToPathItem(commentId))"
        let commentIdPostEscape = commentIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "comment_id"), with: commentIdPostEscape, options: .literal, range: nil)
        let typePreEscape = "\(APIHelper.mapValueToPathItem(type))"
        let typePostEscape = typePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "type"), with: typePostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(DeleteCommentReactionResponse.self, from: $0)
        }
    }

    open func getCommentReplies(commentId: String, depth: Int?, sort: String?, repliesLimit: Int?, limit: Int?, prev: String?, next: String?) async throws -> GetCommentRepliesResponse {
        var path = "/api/v2/feeds/comments/{comment_id}/replies"

        let commentIdPreEscape = "\(APIHelper.mapValueToPathItem(commentId))"
        let commentIdPostEscape = commentIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "comment_id"), with: commentIdPostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "depth": (wrappedValue: depth?.encodeToJSON(), isExplode: true),
            "sort": (wrappedValue: sort?.encodeToJSON(), isExplode: true),
            "replies_limit": (wrappedValue: repliesLimit?.encodeToJSON(), isExplode: true),
            "limit": (wrappedValue: limit?.encodeToJSON(), isExplode: true),
            "prev": (wrappedValue: prev?.encodeToJSON(), isExplode: true),
            "next": (wrappedValue: next?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(GetCommentRepliesResponse.self, from: $0)
        }
    }

    open func deleteFeed(feedGroupId: String, feedId: String, hardDelete: Bool?) async throws -> DeleteFeedResponse {
        var path = "/api/v2/feeds/feed_groups/{feed_group_id}/feeds/{feed_id}"

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

    open func getOrCreateFeed(feedGroupId: String, feedId: String, getOrCreateFeedRequest: GetOrCreateFeedRequest) async throws -> GetOrCreateFeedResponse {
        var path = "/api/v2/feeds/feed_groups/{feed_group_id}/feeds/{feed_id}"

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

    open func updateFeed(feedGroupId: String, feedId: String, updateFeedRequest: UpdateFeedRequest) async throws -> UpdateFeedResponse {
        var path = "/api/v2/feeds/feed_groups/{feed_group_id}/feeds/{feed_id}"

        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)
        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PUT",
            request: updateFeedRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpdateFeedResponse.self, from: $0)
        }
    }

    open func markActivity(feedGroupId: String, feedId: String, markActivityRequest: MarkActivityRequest) async throws -> Response {
        var path = "/api/v2/feeds/feed_groups/{feed_group_id}/feeds/{feed_id}/activities/mark/batch"

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
        var path = "/api/v2/feeds/feed_groups/{feed_group_id}/feeds/{feed_id}/activities/{activity_id}/pin"

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
        var path = "/api/v2/feeds/feed_groups/{feed_group_id}/feeds/{feed_id}/activities/{activity_id}/pin"

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

    open func updateFeedMembers(feedGroupId: String, feedId: String, updateFeedMembersRequest: UpdateFeedMembersRequest) async throws -> UpdateFeedMembersResponse {
        var path = "/api/v2/feeds/feed_groups/{feed_group_id}/feeds/{feed_id}/members"

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
            try self.jsonDecoder.decode(UpdateFeedMembersResponse.self, from: $0)
        }
    }

    open func acceptFeedMemberInvite(feedId: String, feedGroupId: String) async throws -> AcceptFeedMemberInviteResponse {
        var path = "/api/v2/feeds/feed_groups/{feed_group_id}/feeds/{feed_id}/members/accept"

        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)
        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AcceptFeedMemberInviteResponse.self, from: $0)
        }
    }

    open func queryFeedMembers(feedGroupId: String, feedId: String, queryFeedMembersRequest: QueryFeedMembersRequest) async throws -> QueryFeedMembersResponse {
        var path = "/api/v2/feeds/feed_groups/{feed_group_id}/feeds/{feed_id}/members/query"

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

    open func rejectFeedMemberInvite(feedGroupId: String, feedId: String) async throws -> RejectFeedMemberInviteResponse {
        var path = "/api/v2/feeds/feed_groups/{feed_group_id}/feeds/{feed_id}/members/reject"

        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)
        let feedIdPreEscape = "\(APIHelper.mapValueToPathItem(feedId))"
        let feedIdPostEscape = feedIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_id"), with: feedIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(RejectFeedMemberInviteResponse.self, from: $0)
        }
    }

    open func getFollowSuggestions(feedGroupId: String, limit: Int?) async throws -> GetFollowSuggestionsResponse {
        var path = "/api/v2/feeds/feed_groups/{feed_group_id}/follow_suggestions"

        let feedGroupIdPreEscape = "\(APIHelper.mapValueToPathItem(feedGroupId))"
        let feedGroupIdPostEscape = feedGroupIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "feed_group_id"), with: feedGroupIdPostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "limit": (wrappedValue: limit?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(GetFollowSuggestionsResponse.self, from: $0)
        }
    }

    open func createFeedsBatch(createFeedsBatchRequest: CreateFeedsBatchRequest) async throws -> CreateFeedsBatchResponse {
        let path = "/api/v2/feeds/feeds/batch"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: createFeedsBatchRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(CreateFeedsBatchResponse.self, from: $0)
        }
    }

    open func feedsQueryFeeds(queryFeedsRequest: QueryFeedsRequest) async throws -> QueryFeedsResponse {
        let path = "/api/v2/feeds/feeds/query"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: queryFeedsRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryFeedsResponse.self, from: $0)
        }
    }

    open func updateFollow(updateFollowRequest: UpdateFollowRequest) async throws -> UpdateFollowResponse {
        let path = "/api/v2/feeds/follows"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PATCH",
            request: updateFollowRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpdateFollowResponse.self, from: $0)
        }
    }

    open func follow(singleFollowRequest: SingleFollowRequest) async throws -> SingleFollowResponse {
        let path = "/api/v2/feeds/follows"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: singleFollowRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(SingleFollowResponse.self, from: $0)
        }
    }

    open func acceptFollow(acceptFollowRequest: AcceptFollowRequest) async throws -> AcceptFollowResponse {
        let path = "/api/v2/feeds/follows/accept"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: acceptFollowRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(AcceptFollowResponse.self, from: $0)
        }
    }

    open func followBatch(followBatchRequest: FollowBatchRequest) async throws -> FollowBatchResponse {
        let path = "/api/v2/feeds/follows/batch"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: followBatchRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(FollowBatchResponse.self, from: $0)
        }
    }

    open func queryFollows(queryFollowsRequest: QueryFollowsRequest) async throws -> QueryFollowsResponse {
        let path = "/api/v2/feeds/follows/query"

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
        let path = "/api/v2/feeds/follows/reject"

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
        var path = "/api/v2/feeds/follows/{source}/{target}"

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

    open func createGuest(createGuestRequest: CreateGuestRequest) async throws -> CreateGuestResponse {
        let path = "/api/v2/guest"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: createGuestRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(CreateGuestResponse.self, from: $0)
        }
    }

    open func ban(banRequest: BanRequest) async throws -> BanResponse {
        let path = "/api/v2/moderation/ban"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: banRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(BanResponse.self, from: $0)
        }
    }

    open func upsertConfig(upsertConfigRequest: UpsertConfigRequest) async throws -> UpsertConfigResponse {
        let path = "/api/v2/moderation/config"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: upsertConfigRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpsertConfigResponse.self, from: $0)
        }
    }

    open func deleteConfig(key: String, team: String?) async throws -> DeleteModerationConfigResponse {
        var path = "/api/v2/moderation/config/{key}"

        let keyPreEscape = "\(APIHelper.mapValueToPathItem(key))"
        let keyPostEscape = keyPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "key"), with: keyPostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "team": (wrappedValue: team?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(DeleteModerationConfigResponse.self, from: $0)
        }
    }

    open func getConfig(key: String, team: String?) async throws -> GetConfigResponse {
        var path = "/api/v2/moderation/config/{key}"

        let keyPreEscape = "\(APIHelper.mapValueToPathItem(key))"
        let keyPostEscape = keyPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "key"), with: keyPostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "team": (wrappedValue: team?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(GetConfigResponse.self, from: $0)
        }
    }

    open func queryModerationConfigs(queryModerationConfigsRequest: QueryModerationConfigsRequest) async throws -> QueryModerationConfigsResponse {
        let path = "/api/v2/moderation/configs"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: queryModerationConfigsRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryModerationConfigsResponse.self, from: $0)
        }
    }

    open func flag(flagRequest: FlagRequest) async throws -> FlagResponse {
        let path = "/api/v2/moderation/flag"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: flagRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(FlagResponse.self, from: $0)
        }
    }

    open func mute(muteRequest: MuteRequest) async throws -> MuteResponse {
        let path = "/api/v2/moderation/mute"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: muteRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(MuteResponse.self, from: $0)
        }
    }

    open func queryReviewQueue(queryReviewQueueRequest: QueryReviewQueueRequest) async throws -> QueryReviewQueueResponse {
        let path = "/api/v2/moderation/review_queue"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: queryReviewQueueRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryReviewQueueResponse.self, from: $0)
        }
    }

    open func submitAction(submitActionRequest: SubmitActionRequest) async throws -> SubmitActionResponse {
        let path = "/api/v2/moderation/submit_action"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: submitActionRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(SubmitActionResponse.self, from: $0)
        }
    }

    open func getOG(url: String) async throws -> GetOGResponse {
        let path = "/api/v2/og"

        let queryParams = APIHelper.mapValuesToQueryItems([
            "url": (wrappedValue: url.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(GetOGResponse.self, from: $0)
        }
    }

    open func createPoll(createPollRequest: CreatePollRequest) async throws -> PollResponse {
        let path = "/api/v2/polls"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: createPollRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(PollResponse.self, from: $0)
        }
    }

    open func updatePoll(updatePollRequest: UpdatePollRequest) async throws -> PollResponse {
        let path = "/api/v2/polls"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PUT",
            request: updatePollRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(PollResponse.self, from: $0)
        }
    }

    open func queryPolls(userId: String?, queryPollsRequest: QueryPollsRequest) async throws -> QueryPollsResponse {
        let path = "/api/v2/polls/query"

        let queryParams = APIHelper.mapValuesToQueryItems([
            "user_id": (wrappedValue: userId?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "POST",
            request: queryPollsRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryPollsResponse.self, from: $0)
        }
    }

    open func deletePoll(pollId: String, userId: String?) async throws -> Response {
        var path = "/api/v2/polls/{poll_id}"

        let pollIdPreEscape = "\(APIHelper.mapValueToPathItem(pollId))"
        let pollIdPostEscape = pollIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "poll_id"), with: pollIdPostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "user_id": (wrappedValue: userId?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(Response.self, from: $0)
        }
    }

    open func getPoll(pollId: String, userId: String?) async throws -> PollResponse {
        var path = "/api/v2/polls/{poll_id}"

        let pollIdPreEscape = "\(APIHelper.mapValueToPathItem(pollId))"
        let pollIdPostEscape = pollIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "poll_id"), with: pollIdPostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "user_id": (wrappedValue: userId?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(PollResponse.self, from: $0)
        }
    }

    open func updatePollPartial(pollId: String, updatePollPartialRequest: UpdatePollPartialRequest) async throws -> PollResponse {
        var path = "/api/v2/polls/{poll_id}"

        let pollIdPreEscape = "\(APIHelper.mapValueToPathItem(pollId))"
        let pollIdPostEscape = pollIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "poll_id"), with: pollIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PATCH",
            request: updatePollPartialRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(PollResponse.self, from: $0)
        }
    }

    open func createPollOption(pollId: String, createPollOptionRequest: CreatePollOptionRequest) async throws -> PollOptionResponse {
        var path = "/api/v2/polls/{poll_id}/options"

        let pollIdPreEscape = "\(APIHelper.mapValueToPathItem(pollId))"
        let pollIdPostEscape = pollIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "poll_id"), with: pollIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: createPollOptionRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(PollOptionResponse.self, from: $0)
        }
    }

    open func updatePollOption(pollId: String, updatePollOptionRequest: UpdatePollOptionRequest) async throws -> PollOptionResponse {
        var path = "/api/v2/polls/{poll_id}/options"

        let pollIdPreEscape = "\(APIHelper.mapValueToPathItem(pollId))"
        let pollIdPostEscape = pollIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "poll_id"), with: pollIdPostEscape, options: .literal, range: nil)

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PUT",
            request: updatePollOptionRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(PollOptionResponse.self, from: $0)
        }
    }

    open func deletePollOption(pollId: String, optionId: String, userId: String?) async throws -> Response {
        var path = "/api/v2/polls/{poll_id}/options/{option_id}"

        let pollIdPreEscape = "\(APIHelper.mapValueToPathItem(pollId))"
        let pollIdPostEscape = pollIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "poll_id"), with: pollIdPostEscape, options: .literal, range: nil)
        let optionIdPreEscape = "\(APIHelper.mapValueToPathItem(optionId))"
        let optionIdPostEscape = optionIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "option_id"), with: optionIdPostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "user_id": (wrappedValue: userId?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(Response.self, from: $0)
        }
    }

    open func getPollOption(pollId: String, optionId: String, userId: String?) async throws -> PollOptionResponse {
        var path = "/api/v2/polls/{poll_id}/options/{option_id}"

        let pollIdPreEscape = "\(APIHelper.mapValueToPathItem(pollId))"
        let pollIdPostEscape = pollIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "poll_id"), with: pollIdPostEscape, options: .literal, range: nil)
        let optionIdPreEscape = "\(APIHelper.mapValueToPathItem(optionId))"
        let optionIdPostEscape = optionIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "option_id"), with: optionIdPostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "user_id": (wrappedValue: userId?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(PollOptionResponse.self, from: $0)
        }
    }

    open func queryPollVotes(pollId: String, userId: String?, queryPollVotesRequest: QueryPollVotesRequest) async throws -> PollVotesResponse {
        var path = "/api/v2/polls/{poll_id}/votes"

        let pollIdPreEscape = "\(APIHelper.mapValueToPathItem(pollId))"
        let pollIdPostEscape = pollIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: String(format: "{%@}", "poll_id"), with: pollIdPostEscape, options: .literal, range: nil)
        let queryParams = APIHelper.mapValuesToQueryItems([
            "user_id": (wrappedValue: userId?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "POST",
            request: queryPollVotesRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(PollVotesResponse.self, from: $0)
        }
    }

    open func deleteFile(url: String?) async throws -> Response {
        let path = "/api/v2/uploads/file"

        let queryParams = APIHelper.mapValuesToQueryItems([
            "url": (wrappedValue: url?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(Response.self, from: $0)
        }
    }

    open func uploadFile(fileUploadRequest: FileUploadRequest) async throws -> FileUploadResponse {
        let path = "/api/v2/uploads/file"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: fileUploadRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(FileUploadResponse.self, from: $0)
        }
    }

    open func deleteImage(url: String?) async throws -> Response {
        let path = "/api/v2/uploads/image"

        let queryParams = APIHelper.mapValuesToQueryItems([
            "url": (wrappedValue: url?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "DELETE"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(Response.self, from: $0)
        }
    }

    open func uploadImage(imageUploadRequest: ImageUploadRequest) async throws -> ImageUploadResponse {
        let path = "/api/v2/uploads/image"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: imageUploadRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(ImageUploadResponse.self, from: $0)
        }
    }

    open func queryUsers(payload: QueryUsersPayload?) async throws -> QueryUsersResponse {
        let path = "/api/v2/users"

        let queryParams = APIHelper.mapValuesToQueryItems([
            "payload": (wrappedValue: payload?.encodeToJSON(), isExplode: true),

        ])

        let urlRequest = try makeRequest(
            uriPath: path,
            queryParams: queryParams ?? [],
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(QueryUsersResponse.self, from: $0)
        }
    }

    open func updateUsersPartial(updateUsersPartialRequest: UpdateUsersPartialRequest) async throws -> UpdateUsersResponse {
        let path = "/api/v2/users"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PATCH",
            request: updateUsersPartialRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpdateUsersResponse.self, from: $0)
        }
    }

    open func updateUsers(updateUsersRequest: UpdateUsersRequest) async throws -> UpdateUsersResponse {
        let path = "/api/v2/users"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: updateUsersRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UpdateUsersResponse.self, from: $0)
        }
    }

    open func getBlockedUsers() async throws -> GetBlockedUsersResponse {
        let path = "/api/v2/users/block"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(GetBlockedUsersResponse.self, from: $0)
        }
    }

    open func blockUsers(blockUsersRequest: BlockUsersRequest) async throws -> BlockUsersResponse {
        let path = "/api/v2/users/block"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: blockUsersRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(BlockUsersResponse.self, from: $0)
        }
    }

    open func getUserLiveLocations() async throws -> SharedLocationsResponse {
        let path = "/api/v2/users/live_locations"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "GET"
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(SharedLocationsResponse.self, from: $0)
        }
    }

    open func updateLiveLocation(updateLiveLocationRequest: UpdateLiveLocationRequest) async throws -> SharedLocationResponse {
        let path = "/api/v2/users/live_locations"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "PUT",
            request: updateLiveLocationRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(SharedLocationResponse.self, from: $0)
        }
    }

    open func unblockUsers(unblockUsersRequest: UnblockUsersRequest) async throws -> UnblockUsersResponse {
        let path = "/api/v2/users/unblock"

        let urlRequest = try makeRequest(
            uriPath: path,
            httpMethod: "POST",
            request: unblockUsersRequest
        )
        return try await send(request: urlRequest) {
            try self.jsonDecoder.decode(UnblockUsersResponse.self, from: $0)
        }
    }
}

protocol DefaultAPIEndpoints {
    func getApp() async throws -> GetApplicationResponse

    func listBlockLists(team: String?) async throws -> ListBlockListResponse

    func createBlockList(createBlockListRequest: CreateBlockListRequest) async throws -> CreateBlockListResponse

    func deleteBlockList(name: String, team: String?) async throws -> Response

    func updateBlockList(name: String, updateBlockListRequest: UpdateBlockListRequest) async throws -> UpdateBlockListResponse

    func deleteDevice(id: String) async throws -> Response

    func listDevices() async throws -> ListDevicesResponse

    func createDevice(createDeviceRequest: CreateDeviceRequest) async throws -> Response

    func addActivity(addActivityRequest: AddActivityRequest) async throws -> AddActivityResponse

    func upsertActivities(upsertActivitiesRequest: UpsertActivitiesRequest) async throws -> UpsertActivitiesResponse

    func removeActivities(deleteActivitiesRequest: DeleteActivitiesRequest) async throws -> DeleteActivitiesResponse

    func queryActivities(queryActivitiesRequest: QueryActivitiesRequest) async throws -> QueryActivitiesResponse

    func deleteActivity(activityId: String, hardDelete: Bool?) async throws -> DeleteActivityResponse

    func getActivity(activityId: String) async throws -> GetActivityResponse

    func updateActivityPartial(activityId: String, updateActivityPartialRequest: UpdateActivityPartialRequest) async throws -> UpdateActivityPartialResponse

    func updateActivity(activityId: String, updateActivityRequest: UpdateActivityRequest) async throws -> UpdateActivityResponse

    func deleteBookmark(activityId: String, folderId: String?) async throws -> DeleteBookmarkResponse

    func updateBookmark(activityId: String, updateBookmarkRequest: UpdateBookmarkRequest) async throws -> UpdateBookmarkResponse

    func addBookmark(activityId: String, addBookmarkRequest: AddBookmarkRequest) async throws -> AddBookmarkResponse

    func castPollVote(activityId: String, pollId: String, castPollVoteRequest: CastPollVoteRequest) async throws -> PollVoteResponse

    func removePollVote(activityId: String, pollId: String, voteId: String, userId: String?) async throws -> PollVoteResponse

    func addReaction(activityId: String, addReactionRequest: AddReactionRequest) async throws -> AddReactionResponse

    func queryActivityReactions(activityId: String, queryActivityReactionsRequest: QueryActivityReactionsRequest) async throws -> QueryActivityReactionsResponse

    func deleteActivityReaction(activityId: String, type: String) async throws -> DeleteActivityReactionResponse

    func queryBookmarkFolders(queryBookmarkFoldersRequest: QueryBookmarkFoldersRequest) async throws -> QueryBookmarkFoldersResponse

    func queryBookmarks(queryBookmarksRequest: QueryBookmarksRequest) async throws -> QueryBookmarksResponse

    func getComments(objectId: String, objectType: String, depth: Int?, sort: String?, repliesLimit: Int?, limit: Int?, prev: String?, next: String?) async throws -> GetCommentsResponse

    func addComment(addCommentRequest: AddCommentRequest) async throws -> AddCommentResponse

    func addCommentsBatch(addCommentsBatchRequest: AddCommentsBatchRequest) async throws -> AddCommentsBatchResponse

    func queryComments(queryCommentsRequest: QueryCommentsRequest) async throws -> QueryCommentsResponse

    func deleteComment(commentId: String) async throws -> DeleteCommentResponse

    func getComment(commentId: String) async throws -> GetCommentResponse

    func updateComment(commentId: String, updateCommentRequest: UpdateCommentRequest) async throws -> UpdateCommentResponse

    func addCommentReaction(commentId: String, addCommentReactionRequest: AddCommentReactionRequest) async throws -> AddCommentReactionResponse

    func queryCommentReactions(commentId: String, queryCommentReactionsRequest: QueryCommentReactionsRequest) async throws -> QueryCommentReactionsResponse

    func deleteCommentReaction(commentId: String, type: String) async throws -> DeleteCommentReactionResponse

    func getCommentReplies(commentId: String, depth: Int?, sort: String?, repliesLimit: Int?, limit: Int?, prev: String?, next: String?) async throws -> GetCommentRepliesResponse

    func deleteFeed(feedGroupId: String, feedId: String, hardDelete: Bool?) async throws -> DeleteFeedResponse

    func getOrCreateFeed(feedGroupId: String, feedId: String, getOrCreateFeedRequest: GetOrCreateFeedRequest) async throws -> GetOrCreateFeedResponse

    func updateFeed(feedGroupId: String, feedId: String, updateFeedRequest: UpdateFeedRequest) async throws -> UpdateFeedResponse

    func markActivity(feedGroupId: String, feedId: String, markActivityRequest: MarkActivityRequest) async throws -> Response

    func unpinActivity(feedGroupId: String, feedId: String, activityId: String) async throws -> UnpinActivityResponse

    func pinActivity(feedGroupId: String, feedId: String, activityId: String) async throws -> PinActivityResponse

    func updateFeedMembers(feedGroupId: String, feedId: String, updateFeedMembersRequest: UpdateFeedMembersRequest) async throws -> UpdateFeedMembersResponse

    func acceptFeedMemberInvite(feedId: String, feedGroupId: String) async throws -> AcceptFeedMemberInviteResponse

    func queryFeedMembers(feedGroupId: String, feedId: String, queryFeedMembersRequest: QueryFeedMembersRequest) async throws -> QueryFeedMembersResponse

    func rejectFeedMemberInvite(feedGroupId: String, feedId: String) async throws -> RejectFeedMemberInviteResponse

    func getFollowSuggestions(feedGroupId: String, limit: Int?) async throws -> GetFollowSuggestionsResponse

    func createFeedsBatch(createFeedsBatchRequest: CreateFeedsBatchRequest) async throws -> CreateFeedsBatchResponse

    func feedsQueryFeeds(queryFeedsRequest: QueryFeedsRequest) async throws -> QueryFeedsResponse

    func updateFollow(updateFollowRequest: UpdateFollowRequest) async throws -> UpdateFollowResponse

    func follow(singleFollowRequest: SingleFollowRequest) async throws -> SingleFollowResponse

    func acceptFollow(acceptFollowRequest: AcceptFollowRequest) async throws -> AcceptFollowResponse

    func followBatch(followBatchRequest: FollowBatchRequest) async throws -> FollowBatchResponse

    func queryFollows(queryFollowsRequest: QueryFollowsRequest) async throws -> QueryFollowsResponse

    func rejectFollow(rejectFollowRequest: RejectFollowRequest) async throws -> RejectFollowResponse

    func unfollow(source: String, target: String) async throws -> UnfollowResponse

    func createGuest(createGuestRequest: CreateGuestRequest) async throws -> CreateGuestResponse

    func ban(banRequest: BanRequest) async throws -> BanResponse

    func upsertConfig(upsertConfigRequest: UpsertConfigRequest) async throws -> UpsertConfigResponse

    func deleteConfig(key: String, team: String?) async throws -> DeleteModerationConfigResponse

    func getConfig(key: String, team: String?) async throws -> GetConfigResponse

    func queryModerationConfigs(queryModerationConfigsRequest: QueryModerationConfigsRequest) async throws -> QueryModerationConfigsResponse

    func flag(flagRequest: FlagRequest) async throws -> FlagResponse

    func mute(muteRequest: MuteRequest) async throws -> MuteResponse

    func queryReviewQueue(queryReviewQueueRequest: QueryReviewQueueRequest) async throws -> QueryReviewQueueResponse

    func submitAction(submitActionRequest: SubmitActionRequest) async throws -> SubmitActionResponse

    func getOG(url: String) async throws -> GetOGResponse

    func createPoll(createPollRequest: CreatePollRequest) async throws -> PollResponse

    func updatePoll(updatePollRequest: UpdatePollRequest) async throws -> PollResponse

    func queryPolls(userId: String?, queryPollsRequest: QueryPollsRequest) async throws -> QueryPollsResponse

    func deletePoll(pollId: String, userId: String?) async throws -> Response

    func getPoll(pollId: String, userId: String?) async throws -> PollResponse

    func updatePollPartial(pollId: String, updatePollPartialRequest: UpdatePollPartialRequest) async throws -> PollResponse

    func createPollOption(pollId: String, createPollOptionRequest: CreatePollOptionRequest) async throws -> PollOptionResponse

    func updatePollOption(pollId: String, updatePollOptionRequest: UpdatePollOptionRequest) async throws -> PollOptionResponse

    func deletePollOption(pollId: String, optionId: String, userId: String?) async throws -> Response

    func getPollOption(pollId: String, optionId: String, userId: String?) async throws -> PollOptionResponse

    func queryPollVotes(pollId: String, userId: String?, queryPollVotesRequest: QueryPollVotesRequest) async throws -> PollVotesResponse

    func deleteFile(url: String?) async throws -> Response

    func uploadFile(fileUploadRequest: FileUploadRequest) async throws -> FileUploadResponse

    func deleteImage(url: String?) async throws -> Response

    func uploadImage(imageUploadRequest: ImageUploadRequest) async throws -> ImageUploadResponse

    func queryUsers(payload: QueryUsersPayload?) async throws -> QueryUsersResponse

    func updateUsersPartial(updateUsersPartialRequest: UpdateUsersPartialRequest) async throws -> UpdateUsersResponse

    func updateUsers(updateUsersRequest: UpdateUsersRequest) async throws -> UpdateUsersResponse

    func getBlockedUsers() async throws -> GetBlockedUsersResponse

    func blockUsers(blockUsersRequest: BlockUsersRequest) async throws -> BlockUsersResponse

    func getUserLiveLocations() async throws -> SharedLocationsResponse

    func updateLiveLocation(updateLiveLocationRequest: UpdateLiveLocationRequest) async throws -> SharedLocationResponse

    func unblockUsers(unblockUsersRequest: UnblockUsersRequest) async throws -> UnblockUsersResponse
}
