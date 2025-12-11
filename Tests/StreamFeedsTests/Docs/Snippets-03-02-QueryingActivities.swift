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
            filter: .equal(.activityType, "post"),
            sort: [Sort(field: .createdAt, direction: .reverse)],
            limit: 10
        )
        let activityList = client.activityList(for: query)
        let activities = try await activityList.get()
        
        suppressUnusedWarning(activities)
    }
    
    func queryingActivitiesByText() async throws {
        // search for activities where the text includes the word 'popularity'.
        let query = ActivitiesQuery(
            filter: .query(.text, "popularity")
        )
        let activityList = client.activityList(for: query)
        let activities = try await activityList.get()
        
        suppressUnusedWarning(activities)
    }
    
    func queryingActivitiesBySearchData() async throws {
        // search for activities associated with the campaign ID 'spring-sale-2025'
        let searchValue: [String: RawJSON] = ["campaign": .dictionary(["id": .string("spring-sale-2025")])]
        let query = ActivitiesQuery(
            filter: .contains(.searchData, searchValue)
        )
        let activityList = client.activityList(for: query)
        let activities = try await activityList.get()
        
        // search for activities where the campaign took place in a mall
        let query2 = ActivitiesQuery(
            filter: .pathExists(.searchData, "campaign.location.mall")
        )
        let activityList2 = client.activityList(for: query2)
        let activities2 = try await activityList2.get()
        
        suppressUnusedWarning(activities)
        suppressUnusedWarning(activities2)
    }
}
