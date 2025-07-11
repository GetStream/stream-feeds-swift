//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct ArrayExtensions_Tests {
    // MARK: - Test Data
    
    struct TestItem: Identifiable, Equatable {
        let id: String
        let value: Int
        var parentId: String?
        var subitems: [TestItem]?
    }
    
    // MARK: - Test Sort Field
    
    struct TestItemSortField: SortField {
        public typealias Model = TestItem
        public let comparator: AnySortComparator<Model>
        public let remote: String
        
        public init<Value>(_ remote: String, localValue: @escaping @Sendable (Model) -> Value) where Value: Comparable {
            comparator = SortComparator(localValue).toAny()
            self.remote = remote
        }
        
        public static let value = Self("value", localValue: \.value)
    }
    
    // MARK: - Non-Sorted Array Tests
    
    @Test("Insert by ID in non-sorted array")
    func insertById() {
        var array: [TestItem] = []
        
        // Test inserting new item
        let item1 = TestItem(id: "1", value: 1)
        array.insert(byId: item1)
        #expect(array.count == 1)
        #expect(array.first == item1)
        
        // Test replacing existing item
        let item1Updated = TestItem(id: "1", value: 2)
        array.insert(byId: item1Updated)
        #expect(array.count == 1)
        #expect(array.first == item1Updated)
        
        // Test inserting another item
        let item2 = TestItem(id: "2", value: 3)
        array.insert(byId: item2)
        #expect(array.count == 2)
        #expect(array.first == item2) // Should be at start
    }
    
    @Test("Remove by ID in non-sorted array")
    func removeById() {
        var array: [TestItem] = [
            TestItem(id: "1", value: 1),
            TestItem(id: "2", value: 2),
            TestItem(id: "3", value: 3)
        ]
        
        // Test removing existing item
        let itemToRemove = TestItem(id: "2", value: 2)
        array.remove(byId: itemToRemove.id)
        #expect(array.count == 2)
        #expect(!array.contains(where: { $0.id == "2" }))
        
        // Test removing non-existent item
        let nonExistentItem = TestItem(id: "4", value: 4)
        array.remove(byId: nonExistentItem.id)
        #expect(array.count == 2) // Count should remain unchanged
    }
    
    // MARK: - Sorted Array Tests
    
    @Test("Sorted insert")
    func testSortedInsert() {
        var array: [TestItem] = []
        let sorting: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
        
        // Test inserting items in random order
        let item3 = TestItem(id: "3", value: 3)
        let item1 = TestItem(id: "1", value: 1)
        let item2 = TestItem(id: "2", value: 2)
        
        array.sortedInsert(item3, using: sorting)
        array.sortedInsert(item1, using: sorting)
        array.sortedInsert(item2, using: sorting)
        
        // Verify order
        #expect(array.count == 3)
        #expect(array[0].value == 1)
        #expect(array[1].value == 2)
        #expect(array[2].value == 3)
        
        // Test replacing existing item
        let item1Updated = TestItem(id: "1", value: 4)
        array.sortedInsert(item1Updated, using: sorting)
        #expect(array.count == 3)
        #expect(array[0].value == 2)
        #expect(array[1].value == 3)
        #expect(array[2].value == 4)
    }
    
    @Test("Sorted remove")
    func testSortedRemove() {
        var array: [TestItem] = [
            TestItem(id: "1", value: 1),
            TestItem(id: "2", value: 2),
            TestItem(id: "3", value: 3)
        ]
        let sorting: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
        
        // Test removing middle item
        let itemToRemove = TestItem(id: "2", value: 2)
        array.sortedRemove(itemToRemove, using: sorting)
        #expect(array.count == 2)
        #expect(!array.contains(where: { $0.id == "2" }))
        #expect(array[0].value == 1)
        #expect(array[1].value == 3)
        
        // Test removing non-existent item
        let nonExistentItem = TestItem(id: "4", value: 4)
        array.sortedRemove(nonExistentItem, using: sorting)
        #expect(array.count == 2) // Count should remain unchanged
    }
    
    @Test("Sorted replace - existing element")
    func testSortedReplace() {
        var array: [TestItem] = [
            TestItem(id: "1", value: 1),
            TestItem(id: "2", value: 2),
            TestItem(id: "3", value: 3)
        ]
        let sorting: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
        
        // Test replacing with same sort position
        let item2Updated = TestItem(id: "2", value: 2) // Same value, should stay in same position
        array.sortedReplace(item2Updated, using: sorting)
        #expect(array.count == 3)
        #expect(array[1].id == "2")
        #expect(array[1].value == 2)
        
        // Test replacing with different sort position (moves to end)
        let item2Moved = TestItem(id: "2", value: 5)
        array.sortedReplace(item2Moved, using: sorting)
        #expect(array.count == 3)
        #expect(array[0].value == 1)
        #expect(array[1].value == 3)
        #expect(array[2].value == 5)
        #expect(array[2].id == "2")
        
        // Test replacing with different sort position (moves to beginning)
        let item2MovedToStart = TestItem(id: "2", value: 0)
        array.sortedReplace(item2MovedToStart, using: sorting)
        #expect(array.count == 3)
        #expect(array[0].value == 0)
        #expect(array[0].id == "2")
        #expect(array[1].value == 1)
        #expect(array[2].value == 3)
    }
    
    @Test("Sorted replace - non-existent element")
    func sortedReplaceNonExistent() {
        var array: [TestItem] = [
            TestItem(id: "1", value: 1),
            TestItem(id: "2", value: 2),
            TestItem(id: "3", value: 3)
        ]
        let sorting: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
        
        // Test replacing non-existent element
        let nonExistentItem = TestItem(id: "4", value: 4)
        array.sortedReplace(nonExistentItem, using: sorting)
        #expect(array.count == 3) // Count should remain unchanged
        #expect(array[0].value == 1)
        #expect(array[1].value == 2)
        #expect(array[2].value == 3)
    }
    
    @Test("Sorted replace - empty array")
    func sortedReplaceEmptyArray() {
        var array: [TestItem] = []
        let sorting: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
        
        // Test replacing in empty array
        let item = TestItem(id: "1", value: 1)
        array.sortedReplace(item, using: sorting)
        #expect(array.isEmpty) // Should remain empty
    }
    
    @Test("Sorted replace - single element array")
    func sortedReplaceSingleElement() {
        var array: [TestItem] = [TestItem(id: "1", value: 1)]
        let sorting: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
        
        // Test replacing with same value
        let item1Same = TestItem(id: "1", value: 1)
        array.sortedReplace(item1Same, using: sorting)
        #expect(array.count == 1)
        #expect(array[0].id == "1")
        #expect(array[0].value == 1)
        
        // Test replacing with different value
        let item1Different = TestItem(id: "1", value: 5)
        array.sortedReplace(item1Different, using: sorting)
        #expect(array.count == 1)
        #expect(array[0].id == "1")
        #expect(array[0].value == 5)
    }
    
    @Test("Sorted replace - multiple replacements")
    func sortedReplaceMultiple() {
        var array: [TestItem] = [
            TestItem(id: "1", value: 1),
            TestItem(id: "2", value: 2),
            TestItem(id: "3", value: 3)
        ]
        let sorting: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
        
        // Replace multiple elements in sequence
        let item1Updated = TestItem(id: "1", value: 5)
        let item3Updated = TestItem(id: "3", value: 0)
        
        array.sortedReplace(item1Updated, using: sorting)
        array.sortedReplace(item3Updated, using: sorting)
        
        #expect(array.count == 3)
        #expect(array[0].value == 0) // item3 moved to start
        #expect(array[0].id == "3")
        #expect(array[1].value == 2) // item2 unchanged
        #expect(array[1].id == "2")
        #expect(array[2].value == 5) // item1 moved to end
        #expect(array[2].id == "1")
    }
    
    @Test("Sorted replace - maintains sort order")
    func sortedReplaceMaintainsSortOrder() {
        var array: [TestItem] = [
            TestItem(id: "1", value: 1),
            TestItem(id: "2", value: 2),
            TestItem(id: "3", value: 3),
            TestItem(id: "4", value: 4),
            TestItem(id: "5", value: 5)
        ]
        let sorting: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
        
        // Replace elements and verify sort order is maintained
        let item2Updated = TestItem(id: "2", value: 6)
        let item4Updated = TestItem(id: "4", value: 0)
        
        array.sortedReplace(item2Updated, using: sorting)
        array.sortedReplace(item4Updated, using: sorting)
        
        #expect(array.count == 5)
        
        // Verify sort order is maintained
        for i in 0..<array.count - 1 {
            #expect(array[i].value <= array[i + 1].value)
        }
        
        // Verify specific positions
        #expect(array[0].value == 0) // item4
        #expect(array[1].value == 1) // item1
        #expect(array[2].value == 3) // item3
        #expect(array[3].value == 5) // item5
        #expect(array[4].value == 6) // item2
    }
    
    // MARK: - Sorted Merge Tests
    
    @Test("Sorted merge - empty arrays")
    func sortedMergeEmptyArrays() {
        let sorting: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
        
        // Both arrays empty
        let empty1: [TestItem] = []
        let empty2: [TestItem] = []
        let result1 = empty1.sortedMerge(empty2, using: sorting)
        #expect(result1.isEmpty)
        
        // First array empty
        let array2: [TestItem] = [
            TestItem(id: "1", value: 1),
            TestItem(id: "2", value: 2)
        ]
        let result2 = empty1.sortedMerge(array2, using: sorting)
        #expect(result2.count == 2)
        #expect(result2[0].value == 1)
        #expect(result2[1].value == 2)
        
        // Second array empty
        let array1: [TestItem] = [
            TestItem(id: "3", value: 3),
            TestItem(id: "4", value: 4)
        ]
        let result3 = array1.sortedMerge(empty2, using: sorting)
        #expect(result3.count == 2)
        #expect(result3[0].value == 3)
        #expect(result3[1].value == 4)
    }
    
    @Test("Sorted merge - no duplicates")
    func sortedMergeNoDuplicates() {
        let array1: [TestItem] = [
            TestItem(id: "1", value: 1),
            TestItem(id: "3", value: 3),
            TestItem(id: "5", value: 5)
        ]
        let array2: [TestItem] = [
            TestItem(id: "2", value: 2),
            TestItem(id: "4", value: 4),
            TestItem(id: "6", value: 6)
        ]
        let sorting: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
        
        let result = array1.sortedMerge(array2, using: sorting)
        #expect(result.count == 6)
        
        // Verify order
        for i in 0..<result.count {
            #expect(result[i].value == i + 1)
        }
    }
    
    @Test("Sorted merge - with duplicates")
    func sortedMergeWithDuplicates() {
        let array1: [TestItem] = [
            TestItem(id: "1", value: 1),
            TestItem(id: "2", value: 2),
            TestItem(id: "3", value: 3)
        ]
        let array2: [TestItem] = [
            TestItem(id: "2", value: 2), // Duplicate with different value
            TestItem(id: "4", value: 4),
            TestItem(id: "5", value: 5)
        ]
        let sorting: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
        
        let result = array1.sortedMerge(array2, using: sorting)
        #expect(result.count == 5) // Should have 5 unique items
        
        // Verify order and that incoming elements are preferred
        #expect(result[0].value == 1)
        #expect(result[1].value == 2) // Should be from array2
        #expect(result[2].value == 3)
        #expect(result[3].value == 4)
        #expect(result[4].value == 5)
    }
    
    @Test("Sorted merge - all duplicates")
    func sortedMergeAllDuplicates() {
        let array1: [TestItem] = [
            TestItem(id: "1", value: 1),
            TestItem(id: "2", value: 2)
        ]
        let array2: [TestItem] = [
            TestItem(id: "1", value: 10), // Same ID, different value
            TestItem(id: "2", value: 20) // Same ID, different value
        ]
        let sorting: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
        
        let result = array1.sortedMerge(array2, using: sorting)
        #expect(result.count == 2) // Should have 2 unique items
        
        // Verify that incoming elements are preferred
        #expect(result[0].value == 10)
        #expect(result[1].value == 20)
    }
    
    @Test("Sorted merge - different sizes")
    func sortedMergeDifferentSizes() {
        let array1: [TestItem] = [
            TestItem(id: "1", value: 1),
            TestItem(id: "3", value: 3)
        ]
        let array2: [TestItem] = [
            TestItem(id: "2", value: 2),
            TestItem(id: "4", value: 4),
            TestItem(id: "5", value: 5),
            TestItem(id: "6", value: 6)
        ]
        let sorting: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
        
        let result = array1.sortedMerge(array2, using: sorting)
        #expect(result.count == 6)
        
        // Verify order
        for i in 0..<result.count {
            #expect(result[i].value == i + 1)
        }
    }
    
    // MARK: - Nested Update
    
    private func makeNestedItems() -> [TestItem] {
        (0...2).map { level1Id in
            var item = TestItem(id: "\(level1Id)", value: level1Id, subitems: nil)
            if level1Id == 1 {
                item.subitems = [TestItem(
                    id: "\(level1Id)-1",
                    value: level1Id * 10 + 1,
                    parentId: "\(level1Id)",
                    subitems: (0...4).map { TestItem(id: "\(level1Id)-1-\($0)", value: level1Id * 100 + 10 + $0, parentId: "\(level1Id)-1") }
                )]
            }
            if level1Id == 2 {
                item.subitems = (0...1).map { TestItem(id: "\(level1Id)-\($0)", value: level1Id * 10 + $0, parentId: "\(level1Id)") }
            }
            return item
        }
    }
    
    private func nestedSortedIdentifiers(_ items: [TestItem]?) -> [String] {
        guard let items else { return [] }
        var result = [String]()
        for item in items {
            result.append(item.id)
            if let subitems = item.subitems {
                result.append(contentsOf: nestedSortedIdentifiers(subitems))
            }
        }
        return result.sorted()
    }
    
    @Test("Nested update - delete")
    func nestedUpdateDeletion() {
        let items = makeNestedItems()

        var result = items
        result.remove(byId: "1-2", nesting: \.subitems)
        
        let resultIds = nestedSortedIdentifiers(result)
        var expectedIds = nestedSortedIdentifiers(items)
        expectedIds.removeAll(where: { $0 == "1-2" })
        
        #expect(expectedIds.count == resultIds.count)
        #expect(expectedIds == resultIds)
    }
    
    @Test("Nested update - replace subitem")
    func nestedUpdateReplaceSubitem() {
        let items = makeNestedItems()
        
        let updatedItem = TestItem(id: "2-0", value: 5000)
        var result = items
        result.replace(byId: updatedItem, nesting: \.subitems)
        
        let resultValue = result[2].subitems?[0].value
        #expect(updatedItem.value == resultValue)
    }
    
    @Test("Nested update - add subitem")
    func nestedUpdateAddSubitem() {
        let items = makeNestedItems()
        
        let incomingItem = TestItem(id: "ADDED", value: -1, parentId: "0")
        var result = items
        result.insert(byId: incomingItem, parentId: \.parentId, nesting: \.subitems)
        
        #expect(result[0].subitems?.first?.id == "ADDED")
    }
}
