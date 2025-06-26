//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

struct Snippets_03_02_QueryingActivities {
    private var client: FeedsClient!
    private var feed: Feed!
    
    func activitySearchQueries() async throws {
        let query = ActivitiesQuery(
            filter: .equal(.type, value: "post"),
            sort: [Sort(field: .createdAt, direction: .reverse)],
            limit: 10
        )
        let activities = try await feed.queryActivities(with: query)
        
        suppressUnusedWarning(activities)
    }
    
    func queryingActivitiesByText() async throws {
        // search for activities where the text includes the word 'popularity'.
        let query = ActivitiesQuery(
            filter: .query(.text, value: "popularity")
        )
        let activities = try await feed.queryActivities(with: query)
        
        suppressUnusedWarning(activities)
    }
    
    func queryingActivitiesBySearchData() async throws {
        // search for activities associated with the campaign ID 'spring-sale-2025'
        let searchValue: [String: RawJSON] = ["campaign": .dictionary(["id": .string("spring-sale-2025")])]
        let query = ActivitiesQuery(
            filter: .contains(.searchData, value: searchValue)
        )
        let activities = try await feed.queryActivities(with: query)
        
        // search for activities where the campaign took place in a mall
        let query2 = ActivitiesQuery(
            filter: .pathExists(.searchData, value: "campaign.location.mall")
        )
        let activities2 = try await feed.queryActivities(with: query2)
        
        suppressUnusedWarning(activities)
        suppressUnusedWarning(activities2)
    }
}
