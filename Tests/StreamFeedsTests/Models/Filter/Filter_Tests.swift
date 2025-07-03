//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Testing
import StreamCore
@testable import StreamFeeds

struct Filter_Tests {
    
    // MARK: - Test Filter Field
    
    struct TestFilterField: FilterFieldRepresentable {
        public let value: String
        
        public init(value: String) {
            self.value = value
        }
        
        public static let name = Self(value: "name")
        public static let age = Self(value: "age")
        public static let email = Self(value: "email")
        public static let tags = Self(value: "tags")
        public static let createdAt = Self(value: "created_at")
        public static let isActive = Self(value: "is_active")
    }
    
    struct TestFilter: Filter {
        typealias FilterField = TestFilterField
        
        public init(filterOperator: FilterOperator, field: TestFilterField, value: any FilterValue) {
            self.filterOperator = filterOperator
            self.field = field
            self.value = value
        }
        
        public let field: TestFilterField
        public let value: any FilterValue
        public let filterOperator: FilterOperator
    }
    
    // MARK: - Basic Filter Tests
    
    @Test("Equal filter with string value")
    func testEqualFilterWithString() {
        let filter = TestFilter.equal(.name, "John")
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "name": .dictionary(["$eq": .string("John")])
        ]
        
        #expect(json == expected)
    }
    
    @Test("Equal filter with integer value")
    func testEqualFilterWithInteger() {
        let filter = TestFilter.equal(.age, 25)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "age": .dictionary(["$eq": .number(25.0)])
        ]
        
        #expect(json == expected)
    }
    
    @Test("Equal filter with boolean value")
    func testEqualFilterWithBoolean() {
        let filter = TestFilter.equal(.isActive, true)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "is_active": .dictionary(["$eq": .bool(true)])
        ]
        
        #expect(json == expected)
    }
    
    @Test("Equal filter with date value")
    func testEqualFilterWithDate() {
        let date = Date(timeIntervalSince1970: 1640995200) // 2022-01-01 00:00:00 UTC
        let filter = TestFilter.equal(.createdAt, date)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "created_at": .dictionary(["$eq": .string("2022-01-01T00:00:00.000Z")])
        ]
        
        #expect(json == expected)
    }
    
    // MARK: - Comparison Filter Tests
    
    @Test("Greater than filter")
    func testGreaterThanFilter() {
        let filter = TestFilter.greater(.age, 18)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "age": .dictionary(["$gt": .number(18.0)])
        ]
        
        #expect(json == expected)
    }
    
    @Test("Greater than or equal filter")
    func testGreaterThanOrEqualFilter() {
        let filter = TestFilter.greaterOrEqual(.age, 21)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "age": .dictionary(["$gte": .number(21.0)])
        ]
        
        #expect(json == expected)
    }
    
    @Test("Less than filter")
    func testLessThanFilter() {
        let filter = TestFilter.less(.age, 65)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "age": .dictionary(["$lt": .number(65.0)])
        ]
        
        #expect(json == expected)
    }
    
    @Test("Less than or equal filter")
    func testLessThanOrEqualFilter() {
        let filter = TestFilter.lessOrEqual(.age, 30)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "age": .dictionary(["$lte": .number(30.0)])
        ]
        
        #expect(json == expected)
    }
    
    // MARK: - Array and Collection Filter Tests
    
    @Test("In filter with array of strings")
    func testInFilterWithStringArray() {
        let filter = TestFilter.in(.name, ["John", "Jane", "Bob"])
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "name": .dictionary(["$in": .array([.string("John"), .string("Jane"), .string("Bob")])])
        ]
        
        #expect(json == expected)
    }
    
    @Test("In filter with array of integers")
    func testInFilterWithIntegerArray() {
        let filter = TestFilter.in(.age, [18, 21, 25, 30])
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "age": .dictionary(["$in": .array([.number(18.0), .number(21.0), .number(25.0), .number(30.0)])])
        ]
        
        #expect(json == expected)
    }
    
    @Test("Contains filter")
    func testContainsFilter() {
        let filter = TestFilter.contains(.tags, "swift")
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "tags": .dictionary(["$contains": .string("swift")])
        ]
        
        #expect(json == expected)
    }
    
    // MARK: - Text Search Filter Tests
    
    @Test("Query filter")
    func testQueryFilter() {
        let filter = TestFilter.query(.name, "john")
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "name": .dictionary(["$q": .string("john")])
        ]
        
        #expect(json == expected)
    }
    
    @Test("Autocomplete filter")
    func testAutocompleteFilter() {
        let filter = TestFilter.autocomplete(.name, "jo")
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "name": .dictionary(["$autocomplete": .string("jo")])
        ]
        
        #expect(json == expected)
    }
    
    // MARK: - Existence Filter Tests
    
    @Test("Exists filter")
    func testExistsFilter() {
        let filter = TestFilter.exists(.email, true)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "email": .dictionary(["$exists": .bool(true)])
        ]
        
        #expect(json == expected)
    }
    
    @Test("Path exists filter")
    func testPathExistsFilter() {
        let filter = TestFilter.pathExists(.tags, "custom.field")
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "tags": .dictionary(["$path_exists": .string("custom.field")])
        ]
        
        #expect(json == expected)
    }
    
    // MARK: - Complex Filter Tests
    
    @Test("And filter with multiple conditions")
    func testAndFilter() {
        let ageFilter = TestFilter.greater(.age, 18)
        let nameFilter = TestFilter.equal(.name, "John")
        let activeFilter = TestFilter.equal(.isActive, true)
        
        let andFilter = TestFilter.and([ageFilter, nameFilter, activeFilter])
        let json = andFilter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "$and": .array([
                .dictionary(["age": .dictionary(["$gt": .number(18.0)])]),
                .dictionary(["name": .dictionary(["$eq": .string("John")])]),
                .dictionary(["is_active": .dictionary(["$eq": .bool(true)])])
            ])
        ]
        
        #expect(json == expected)
    }
    
    @Test("Or filter with multiple conditions")
    func testOrFilter() {
        let nameFilter1 = TestFilter.equal(.name, "John")
        let nameFilter2 = TestFilter.equal(.name, "Jane")
        
        let orFilter = TestFilter.or([nameFilter1, nameFilter2])
        let json = orFilter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "$or": .array([
                .dictionary(["name": .dictionary(["$eq": .string("John")])]),
                .dictionary(["name": .dictionary(["$eq": .string("Jane")])])
            ])
        ]
        
        #expect(json == expected)
    }
    
    @Test("Nested and/or filters")
    func testNestedAndOrFilters() {
        let ageFilter = TestFilter.greater(.age, 18)
        let nameFilter1 = TestFilter.equal(.name, "John")
        let nameFilter2 = TestFilter.equal(.name, "Jane")
        
        let orFilter = TestFilter.or([nameFilter1, nameFilter2])
        let andFilter = TestFilter.and([ageFilter, orFilter])
        
        let json = andFilter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "$and": .array([
                .dictionary(["age": .dictionary(["$gt": .number(18.0)])]),
                .dictionary([
                    "$or": .array([
                        .dictionary(["name": .dictionary(["$eq": .string("John")])]),
                        .dictionary(["name": .dictionary(["$eq": .string("Jane")])])
                    ])
                ])
            ])
        ]
        
        #expect(json == expected)
    }
    
    // MARK: - URL Filter Tests
    
    @Test("URL filter value")
    func testURLFilterValue() {
        let url = URL(string: "https://example.com")!
        let filter = TestFilter.equal(.email, url)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "email": .dictionary(["$eq": .string("https://example.com")])
        ]
        
        #expect(json == expected)
    }
    
    // MARK: - Dictionary Filter Tests
    
    @Test("Dictionary filter value")
    func testDictionaryFilterValue() {
        let customData: [String: RawJSON] = [
            "key1": .string("value1"),
            "key2": .number(42.0)
        ]
        let filter = TestFilter.equal(.tags, customData)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "tags": .dictionary(["$eq": .dictionary(customData)])
        ]
        
        #expect(json == expected)
    }
    
    // MARK: - Array Filter Tests
    
    @Test("Array filter value")
    func testArrayFilterValue() {
        let arrayValue = ["item1", "item2"]
        let filter = TestFilter.equal(.tags, arrayValue)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "tags": .dictionary(["$eq": .array([.string("item1"), .string("item2")])])
        ]
        
        #expect(json == expected)
    }
    
    // MARK: - Edge Cases
    
    @Test("Empty array in filter")
    func testEmptyArrayInFilter() {
        let arrayValue: [String] = []
        let filter = TestFilter.in(.tags, arrayValue)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "tags": .dictionary(["$in": .array([])])
        ]
        
        #expect(json == expected)
    }
    
    @Test("Empty and filter")
    func testEmptyAndFilter() {
        let subFilters: [TestFilter] = []
        let filter = TestFilter.and(subFilters)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "$and": .array([])
        ]
        
        #expect(json == expected)
    }
    
    @Test("Empty or filter")
    func testEmptyOrFilter() {
        let subFilters: [TestFilter] = []
        let filter = TestFilter.or(subFilters)
        let json = filter.toRawJSON()
        
        let expected: [String: RawJSON] = [
            "$or": .array([])
        ]
        
        #expect(json == expected)
    }
}
