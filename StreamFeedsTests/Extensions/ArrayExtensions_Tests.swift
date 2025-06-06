//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Testing
@testable import StreamFeeds

struct ArrayExtensions_Tests {
    
    // MARK: - Test Data
    
    struct TestItem: Identifiable, Equatable {
        let id: String
        let value: Int
    }
    
    // MARK: - Non-Sorted Array Tests
    
    @Test("Insert by ID in non-sorted array")
    func testInsertById() {
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
    func testRemoveById() {
        var array: [TestItem] = [
            TestItem(id: "1", value: 1),
            TestItem(id: "2", value: 2),
            TestItem(id: "3", value: 3)
        ]
        
        // Test removing existing item
        let itemToRemove = TestItem(id: "2", value: 2)
        array.remove(byId: itemToRemove)
        #expect(array.count == 2)
        #expect(!array.contains(where: { $0.id == "2" }))
        
        // Test removing non-existent item
        let nonExistentItem = TestItem(id: "4", value: 4)
        array.remove(byId: nonExistentItem)
        #expect(array.count == 2) // Count should remain unchanged
    }
    
    // MARK: - Sorted Array Tests
    
    @Test("Sorted insert")
    func testSortedInsert() {
        var array: [TestItem] = []
        let sorting: (TestItem, TestItem) -> Bool = { $0.value < $1.value }
        
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
        let sorting: (TestItem, TestItem) -> Bool = { $0.value < $1.value }
        
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
}
