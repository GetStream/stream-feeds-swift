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
        var value: Int
        var parentId: String?
        var subitems: [TestItem]?
    }
    
    // MARK: - Test Sort Field
    
    struct TestItemSortField: SortField {
        public typealias Model = TestItem
        public let comparator: AnySortComparator<Model>
        public let remote: String
        
        public init<Value>(_ remote: String, localValue: @escaping @Sendable (Model) -> Value) where Value: Comparable {
            comparator = AnySortComparator(localValue: localValue)
            self.remote = remote
        }
        
        public static let value = Self("value", localValue: \.value)
    }
    
    let defaultSortingField: [Sort<TestItemSortField>] = [Sort(field: .value, direction: .forward)]
    let defaultSortingClosure: (TestItem, TestItem) -> Bool = { $0.value < $1.value }
    
    private func makeNestedItems() -> [TestItem] {
        [
            TestItem(id: "0", value: 0, subitems: nil),
            TestItem(id: "1", value: 1, subitems: [
                TestItem(id: "1-1", value: 11, parentId: "1", subitems: [
                    TestItem(id: "1-1-0", value: 110, parentId: "1-1"),
                    TestItem(id: "1-1-1", value: 111, parentId: "1-1"),
                    TestItem(id: "1-1-2", value: 112, parentId: "1-1"),
                    TestItem(id: "1-1-3", value: 113, parentId: "1-1"),
                    TestItem(id: "1-1-4", value: 114, parentId: "1-1")
                ])
            ]),
            TestItem(id: "2", value: 2, subitems: [
                TestItem(id: "2-0", value: 20, parentId: "2"),
                TestItem(id: "2-1", value: 21, parentId: "2")
            ])
        ]
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
    
    // MARK: - Managing Identifiable Elements in Array Without Sorting
    
    @Test func insert_byId_inserts_new_element_at_start_when_id_not_exists() throws {
        var array: [TestItem] = []
        let item = TestItem(id: "1", value: 10)
        
        array.insert(byId: item)
        
        #expect(array.count == 1)
        #expect(array.map(\.id) == ["1"])
        #expect(array.map(\.value) == [10])
    }
    
    @Test func insert_byId_replaces_existing_element_when_id_exists() throws {
        var array = [TestItem(id: "1", value: 10)]
        let updatedItem = TestItem(id: "1", value: 20)
        
        array.insert(byId: updatedItem)
        
        #expect(array.count == 1)
        #expect(array.map(\.id) == ["1"])
        #expect(array.map(\.value) == [20])
    }
    
    @Test func insert_byId_inserts_at_start_when_array_has_existing_elements() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        let newItem = TestItem(id: "3", value: 30)
        
        array.insert(byId: newItem)
        
        #expect(array.count == 3)
        #expect(array.map(\.id) == ["3", "1", "2"])
        #expect(array.map(\.value) == [30, 10, 20])
    }
    
    @Test func insert_byId_handles_empty_array() throws {
        var array: [TestItem] = []
        let item = TestItem(id: "1", value: 10)
        
        array.insert(byId: item)
        
        #expect(array.count == 1)
        #expect(array.map(\.id) == ["1"])
    }
    
    @Test func remove_byId_removes_element_with_matching_id() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        
        array.remove(byId: "1")
        
        #expect(array.count == 1)
        #expect(array.map(\.id) == ["2"])
    }
    
    @Test func remove_byId_does_nothing_when_id_not_found() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        let originalCount = array.count
        
        array.remove(byId: "3")
        
        #expect(array.count == originalCount)
        #expect(array.map(\.id) == ["1", "2"])
    }
    
    @Test func remove_byId_handles_empty_array() throws {
        var array: [TestItem] = []
        
        array.remove(byId: "1")
        
        #expect(array.isEmpty)
    }
    
    @Test func remove_byIds_removes_multiple_elements() throws {
        var array = [
            TestItem(id: "1", value: 10),
            TestItem(id: "2", value: 20),
            TestItem(id: "3", value: 30),
            TestItem(id: "4", value: 40)
        ]
        
        array.remove(byIds: ["1", "3"])
        
        #expect(array.count == 2)
        #expect(array.map(\.id) == ["2", "4"])
    }
    
    @Test func remove_byIds_removes_all_elements_when_all_ids_match() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        
        array.remove(byIds: ["1", "2"])
        
        #expect(array.isEmpty)
    }
    
    @Test func remove_byIds_does_nothing_when_no_ids_match() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        let originalCount = array.count
        
        array.remove(byIds: ["3", "4"])
        
        #expect(array.count == originalCount)
        #expect(array.map(\.id) == ["1", "2"])
    }
    
    @Test func remove_byIds_handles_empty_array() throws {
        var array: [TestItem] = []
        
        array.remove(byIds: ["1", "2"])
        
        #expect(array.isEmpty)
    }
    
    @Test func remove_byIds_handles_empty_ids_array() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        let originalCount = array.count
        
        array.remove(byIds: [])
        
        #expect(array.count == originalCount)
        #expect(array.map(\.id) == ["1", "2"])
    }
    
    @Test func replace_byId_replaces_existing_element() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        let updatedItem = TestItem(id: "1", value: 15)
        
        array.replace(byId: updatedItem)
        
        #expect(array.count == 2)
        #expect(array.map(\.id) == ["1", "2"])
        #expect(array.map(\.value) == [15, 20])
    }
    
    @Test func replace_byId_does_nothing_when_id_not_found() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        let originalArray = array
        
        array.replace(byId: TestItem(id: "3", value: 30))
        
        #expect(array == originalArray)
    }
    
    @Test func replace_byId_handles_empty_array() throws {
        var array: [TestItem] = []
        
        array.replace(byId: TestItem(id: "1", value: 10))
        
        #expect(array.isEmpty)
    }
    
    @Test func replace_byIds_replaces_multiple_elements() throws {
        var array = [
            TestItem(id: "1", value: 10),
            TestItem(id: "2", value: 20),
            TestItem(id: "3", value: 30)
        ]
        let replacements = [
            TestItem(id: "1", value: 15),
            TestItem(id: "3", value: 35)
        ]
        
        array.replace(byIds: replacements)
        
        #expect(array.count == 3)
        #expect(array.map(\.id) == ["1", "2", "3"])
        #expect(array.map(\.value) == [15, 20, 35])
    }
    
    @Test func replace_byIds_handles_duplicate_ids_in_replacements() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        let replacements = [
            TestItem(id: "1", value: 15),
            TestItem(id: "1", value: 20) // Duplicate ID, should use the last one
        ]
        
        array.replace(byIds: replacements)
        
        #expect(array.count == 2)
        #expect(array.map(\.id) == ["1", "2"])
        #expect(array.map(\.value) == [20, 20]) // Should use the last replacement
    }
    
    @Test func replace_byIds_does_nothing_when_no_ids_match() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        let originalArray = array
        let replacements = [TestItem(id: "3", value: 30), TestItem(id: "4", value: 40)]
        
        array.replace(byIds: replacements)
        
        #expect(array == originalArray)
    }
    
    @Test func replace_byIds_handles_empty_array() throws {
        var array: [TestItem] = []
        let replacements = [TestItem(id: "1", value: 10)]
        
        array.replace(byIds: replacements)
        
        #expect(array.isEmpty)
    }
    
    @Test func replace_byIds_handles_empty_replacements_array() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        let originalArray = array
        
        array.replace(byIds: [])
        
        #expect(array == originalArray)
    }
    
    // MARK: - Managing Identifiable Elements in Sorted Array
    
    @Test func sortedInsert_inserts_element_in_correct_sorted_position() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "3", value: 30)]
        let newItem = TestItem(id: "2", value: 20)
        
        array.sortedInsert(newItem, sorting: defaultSortingClosure)
        
        #expect(array.count == 3)
        #expect(array.map(\.id) == ["1", "2", "3"])
        #expect(array.map(\.value) == [10, 20, 30])
    }
    
    @Test func sortedInsert_replaces_duplicate_element() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20), TestItem(id: "3", value: 30)]
        let updatedItem = TestItem(id: "2", value: 25)
        
        array.sortedInsert(updatedItem, sorting: defaultSortingClosure)
        
        #expect(array.count == 3)
        #expect(array.map(\.id) == ["1", "2", "3"])
        #expect(array.map(\.value) == [10, 25, 30])
    }
    
    @Test func sortedInsert_handles_empty_array() throws {
        var array: [TestItem] = []
        let item = TestItem(id: "1", value: 10)
        
        array.sortedInsert(item, sorting: defaultSortingClosure)
        
        #expect(array.count == 1)
        #expect(array.map(\.id) == ["1"])
        #expect(array.map(\.value) == [10])
    }
    
    @Test func sortedInsert_with_sort_field_inserts_element_in_correct_position() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "3", value: 30)]
        let newItem = TestItem(id: "2", value: 20)
        
        array.sortedInsert(newItem, sorting: defaultSortingField)
        
        #expect(array.count == 3)
        #expect(array.map(\.id) == ["1", "2", "3"])
        #expect(array.map(\.value) == [10, 20, 30])
    }
    
    @Test func sortedMerge_merges_elements_in_sorted_order() throws {
        let array = [TestItem(id: "1", value: 10), TestItem(id: "3", value: 30)]
        let incomingElements = [TestItem(id: "2", value: 20), TestItem(id: "4", value: 40)]
        
        let result = array.sortedMerge(incomingElements, sorting: defaultSortingClosure)
        
        #expect(result.count == 4)
        #expect(result.map(\.id) == ["1", "2", "3", "4"])
        #expect(result.map(\.value) == [10, 20, 30, 40])
    }
    
    @Test func sortedMerge_prefers_incoming_elements_over_existing() throws {
        let array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        let incomingElements = [TestItem(id: "1", value: 15), TestItem(id: "3", value: 30)]
        
        let result = array.sortedMerge(incomingElements, sorting: defaultSortingClosure)
        
        #expect(result.count == 3)
        #expect(result.map(\.id) == ["1", "2", "3"])
        #expect(result.map(\.value) == [15, 20, 30])
    }
    
    @Test func sortedMerge_handles_empty_arrays() throws {
        let array: [TestItem] = []
        let incomingElements = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        
        let result = array.sortedMerge(incomingElements, sorting: defaultSortingClosure)
        
        #expect(result.count == 2)
        #expect(result.map(\.id) == ["1", "2"])
        #expect(result.map(\.value) == [10, 20])
    }
    
    @Test func sortedMerge_with_sort_field_merges_elements_correctly() throws {
        let array = [TestItem(id: "1", value: 10), TestItem(id: "3", value: 30)]
        let incomingElements = [TestItem(id: "2", value: 20), TestItem(id: "4", value: 40)]
        
        let result = array.sortedMerge(incomingElements, sorting: defaultSortingField)
        
        #expect(result.count == 4)
        #expect(result.map(\.id) == ["1", "2", "3", "4"])
        #expect(result.map(\.value) == [10, 20, 30, 40])
    }
    
    @Test func sortedRemove_removes_element_from_sorted_array() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20), TestItem(id: "3", value: 30)]
        let elementToRemove = TestItem(id: "2", value: 20)
        
        array.sortedRemove(elementToRemove, nesting: nil, sorting: defaultSortingClosure)
        
        #expect(array.count == 2)
        #expect(array.map(\.id) == ["1", "3"])
        #expect(array.map(\.value) == [10, 30])
    }
    
    @Test func sortedRemove_does_nothing_when_element_not_found() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        let elementToRemove = TestItem(id: "3", value: 30)
        
        array.sortedRemove(elementToRemove, nesting: nil, sorting: defaultSortingClosure)
        
        #expect(array.count == 2)
        #expect(array.map(\.id) == ["1", "2"])
        #expect(array.map(\.value) == [10, 20])
    }
    
    @Test func sortedRemove_handles_empty_array() throws {
        var array: [TestItem] = []
        let elementToRemove = TestItem(id: "1", value: 10)
        
        array.sortedRemove(elementToRemove, nesting: nil, sorting: defaultSortingClosure)
        
        #expect(array.isEmpty)
    }
    
    @Test func sortedRemove_with_sort_field_removes_element() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20), TestItem(id: "3", value: 30)]
        let elementToRemove = TestItem(id: "2", value: 20)
        
        array.sortedRemove(elementToRemove, nesting: nil, sorting: defaultSortingField)
        
        #expect(array.count == 2)
        #expect(array.map(\.id) == ["1", "3"])
        #expect(array.map(\.value) == [10, 30])
    }
    
    @Test func sortedRemove_removes_nested_element() throws {
        var array = makeNestedItems()
        let elementToRemove = TestItem(id: "1-1", value: 11, parentId: "1")
        
        array.sortedRemove(elementToRemove, nesting: \.subitems, sorting: defaultSortingClosure)
        
        #expect(array.count == 3)
        #expect(nestedSortedIdentifiers(array) == ["0", "1", "2", "2-0", "2-1"])
    }
    
    @Test func sortedReplace_replaces_element_in_sorted_array() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20), TestItem(id: "3", value: 30)]
        let replacementElement = TestItem(id: "2", value: 25)
        
        array.sortedReplace(replacementElement, nesting: nil, sorting: defaultSortingClosure)
        
        #expect(array.count == 3)
        #expect(array.map(\.id) == ["1", "2", "3"])
        #expect(array.map(\.value) == [10, 25, 30])
    }
    
    @Test func sortedReplace_does_nothing_when_element_not_found() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        let replacementElement = TestItem(id: "3", value: 30)
        
        array.sortedReplace(replacementElement, nesting: nil, sorting: defaultSortingClosure)
        
        #expect(array.count == 2)
        #expect(array.map(\.id) == ["1", "2"])
        #expect(array.map(\.value) == [10, 20])
    }
    
    @Test func sortedReplace_handles_empty_array() throws {
        var array: [TestItem] = []
        let replacementElement = TestItem(id: "1", value: 10)
        
        array.sortedReplace(replacementElement, nesting: nil, sorting: defaultSortingClosure)
        
        #expect(array.isEmpty)
    }
    
    @Test func sortedReplace_with_sort_field_replaces_element() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20), TestItem(id: "3", value: 30)]
        let replacementElement = TestItem(id: "2", value: 25)
        
        array.sortedReplace(replacementElement, nesting: nil, sorting: defaultSortingField)
        
        #expect(array.count == 3)
        #expect(array.map(\.id) == ["1", "2", "3"])
        #expect(array.map(\.value) == [10, 25, 30])
    }
    
    @Test func sortedReplace_replaces_nested_element() throws {
        var array = makeNestedItems()
        let replacementElement = TestItem(id: "1-1", value: 15, parentId: "1")
        
        array.sortedReplace(replacementElement, nesting: \.subitems, sorting: defaultSortingClosure)
        
        #expect(array.count == 3)
        let nestedItems = array.compactMap(\.subitems).flatMap(\.self)
        #expect(nestedItems.first { $0.id == "1-1" }?.value == 15)
    }
    
    @Test func sortedUpdate_updates_element_in_sorted_array() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20), TestItem(id: "3", value: 30)]
        let elementToUpdate = TestItem(id: "2", value: 20)
        
        array.sortedUpdate(elementToUpdate, nesting: nil, sorting: defaultSortingClosure) { element in
            element.value = 25
        }
        
        #expect(array.count == 3)
        #expect(array.map(\.id) == ["1", "2", "3"])
        #expect(array.map(\.value) == [10, 25, 30])
    }
    
    @Test func sortedUpdate_does_nothing_when_element_not_found() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        let elementToUpdate = TestItem(id: "3", value: 30)
        
        array.sortedUpdate(elementToUpdate, nesting: nil, sorting: defaultSortingClosure) { element in
            element.value = 35
        }
        
        #expect(array.count == 2)
        #expect(array.map(\.id) == ["1", "2"])
        #expect(array.map(\.value) == [10, 20])
    }
    
    @Test func sortedUpdate_handles_empty_array() throws {
        var array: [TestItem] = []
        let elementToUpdate = TestItem(id: "1", value: 10)
        
        array.sortedUpdate(elementToUpdate, nesting: nil, sorting: defaultSortingClosure) { element in
            element.value = 15
        }
        
        #expect(array.isEmpty)
    }
    
    @Test func sortedUpdate_updates_nested_element() throws {
        var array = makeNestedItems()
        let elementToUpdate = TestItem(id: "1-1", value: 11, parentId: "1")
        
        array.sortedUpdate(elementToUpdate, nesting: \.subitems, sorting: defaultSortingClosure) { element in
            element.value = 15
        }
        
        #expect(array.count == 3)
        let nestedItems = array.compactMap(\.subitems).flatMap(\.self)
        #expect(nestedItems.first { $0.id == "1-1" }?.value == 15)
    }
    
    @Test func sortedUpdate_ofId_updates_element_by_id() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20), TestItem(id: "3", value: 30)]
        
        array.sortedUpdate(ofId: "2", nesting: nil, sorting: defaultSortingClosure) { element in
            element.value = 25
        }
        
        #expect(array.count == 3)
        #expect(array.map(\.id) == ["1", "2", "3"])
        #expect(array.map(\.value) == [10, 25, 30])
    }
    
    @Test func sortedUpdate_ofId_does_nothing_when_id_not_found() throws {
        var array = [TestItem(id: "1", value: 10), TestItem(id: "2", value: 20)]
        
        array.sortedUpdate(ofId: "3", nesting: nil, sorting: defaultSortingClosure) { element in
            element.value = 25
        }
        
        #expect(array.count == 2)
        #expect(array.map(\.id) == ["1", "2"])
        #expect(array.map(\.value) == [10, 20])
    }
    
    @Test func sortedUpdate_ofId_handles_empty_array() throws {
        var array: [TestItem] = []
        
        array.sortedUpdate(ofId: "1", nesting: nil, sorting: defaultSortingClosure) { element in
            element.value = 15
        }
        
        #expect(array.isEmpty)
    }
    
    @Test func sortedUpdate_ofId_updates_nested_element_by_id() throws {
        var array = makeNestedItems()
        
        array.sortedUpdate(ofId: "1-1", nesting: \.subitems, sorting: defaultSortingClosure) { element in
            element.value = 15
        }
        
        #expect(array.count == 3)
        let nestedItems = array.compactMap(\.subitems).flatMap(\.self)
        #expect(nestedItems.first { $0.id == "1-1" }?.value == 15)
    }
}
