//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

// MARK: - Inserting, Replacing and Removing Elements

extension Array {
    // MARK: - Managing Identifiable Elements in Array Without Sorting
    
    /// Inserts or replaces an element in the non-sorted array based on its ID.
    /// If an element with the same ID already exists, it will be replaced.
    /// Otherwise, the new element will be inserted at the start of the array.
    ///
    /// - Parameter element: The element to insert or replace.
    mutating func insert(byId element: Element) where Element: Identifiable {
        if let index = firstIndex(where: { $0.id == element.id }) {
            replaceSubrange(index...index, with: CollectionOfOne(element))
        } else {
            insert(element, at: startIndex)
        }
    }
    
    /// Removes an element from the non-sorted array based on its ID.
    ///
    /// - Parameter id: The ID of the element to remove.
    mutating func remove(byId id: Element.ID) where Element: Identifiable {
        guard let index = firstIndex(where: { $0.id == id }) else { return }
        remove(at: index)
    }
    
    /// Removes elements from the non-sorted array based on ID.
    ///
    /// - Parameter ids: Ids of elements to remove.
    mutating func remove(byIds ids: [Element.ID]) where Element: Identifiable {
        let lookup = Set(ids)
        removeAll(where: { lookup.contains($0.id) })
    }
    
    /// Replaces an element from the non-sorted array based on its ID.
    ///
    /// - Parameter element: The new element for replacing the existing one.
    mutating func replace(byId element: Element) where Element: Identifiable {
        guard let index = firstIndex(where: { $0.id == element.id }) else { return }
        replaceSubrange(index...index, with: CollectionOfOne(element))
    }
    
    /// Replaces elements from the non-sorted array based on its ID.
    ///
    /// - Parameter elements: New elements for replacing existing ones.
    mutating func replace(byIds elements: [Element]) where Element: Identifiable {
        var lookup = [Element.ID: Element]()
        lookup.merge(elements.map { ($0.id, $0) }, uniquingKeysWith: { _, new in new })
        let replacements = enumerated().compactMap { index, existing -> (Index, Element)? in
            guard let updated = lookup[existing.id] else { return nil }
            return (index, updated)
        }
        for replacement in replacements {
            replaceSubrange(replacement.0...replacement.0, with: CollectionOfOne(replacement.1))
        }
    }
    
    /// Appends new unique elements at the end while replacing existing duplicate elements.
    mutating func appendReplacingDuplicates(byId incomingElements: [Element]) where Element: Identifiable {
        var incomingLookup = [Element.ID: Element]()
        incomingLookup.merge(incomingElements.map { ($0.id, $0) }, uniquingKeysWith: { _, new in new })
        
        var merged = [Element]()
        merged.reserveCapacity(count + incomingElements.count)
        for existing in self {
            if let incoming = incomingLookup[existing.id] {
                merged.append(incoming)
            } else {
                merged.append(existing)
            }
        }
        self = merged
    }

    // MARK: - Managing Identifiable Elements in Sorted Array
    
    /// Inserts or replaces an element in a sorted array while maintaining the sort order.
    /// If an element with the same ID already exists, it will be replaced.
    /// Otherwise, the new element will be inserted at the appropriate position to maintain the sort order.
    ///
    /// - Parameters:
    ///   - element: The element to insert or replace.
    ///   - sorting: A closure that defines the sort order between two elements.
    mutating func sortedInsert(_ element: Element, by sorting: (Element, Element) -> Bool) where Element: Identifiable {
        let insertionIndex = binarySearchInsertionIndex(for: element, using: sorting)
        insert(element, at: insertionIndex)
        // Look for duplicates
        var distance = 1
        while insertionIndex + distance < endIndex || insertionIndex - distance >= startIndex {
            let nextIndex = index(insertionIndex, offsetBy: distance)
            if nextIndex < endIndex, self[nextIndex].id == element.id {
                remove(at: nextIndex)
                break
            }
            let previousIndex = index(insertionIndex, offsetBy: -distance)
            if previousIndex >= startIndex, self[previousIndex].id == element.id {
                remove(at: previousIndex)
                break
            }
            distance += 1
        }
    }
    
    mutating func sortedInsert<Field>(_ element: Element, using sorting: [Sort<Field>]) where Element == Field.Model, Element: Identifiable, Field: SortField {
        sortedInsert(element, by: sorting.areInIncreasingOrder())
    }
    
    /// Merges two sorted arrays while maintaining the sort order and handling duplicates.
    ///
    /// - Parameters:
    ///   - incomingElements: The sorted array to merge with the current array.
    ///   - areInIncreasingOrder: A closure that defines the sort order between two elements.
    /// - Returns: A new array containing all elements from both arrays, maintaining the sort order.
    /// - Note: This function assumes both arrays are already sorted according to the provided sorting closure.
    /// - Important: When elements with the same ID exist in both arrays, the element from the incoming array is preferred.
    /// - Complexity: O(n + m) where n and m are the lengths of the arrays.
    func sortedMerge(_ incomingElements: [Element], by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] where Element: Identifiable {
        let incomingIds = Set<Element.ID>(incomingElements.map(\.id))
        var mergedResult = [Element]()
        mergedResult.reserveCapacity(count + incomingElements.count)
        var currentIndex = startIndex
        var otherIndex = incomingElements.startIndex
        while currentIndex < endIndex && otherIndex < incomingElements.endIndex {
            if areInIncreasingOrder(self[currentIndex], incomingElements[otherIndex]) {
                // Incoming elements are preferred
                if !incomingIds.contains(self[currentIndex].id) {
                    mergedResult.append(self[currentIndex])
                }
                currentIndex = index(after: currentIndex)
            } else {
                mergedResult.append(incomingElements[otherIndex])
                otherIndex = incomingElements.index(after: otherIndex)
            }
        }
        while currentIndex < endIndex {
            // Incoming elements are preferred
            if !incomingIds.contains(self[currentIndex].id) {
                mergedResult.append(self[currentIndex])
            }
            currentIndex = index(after: currentIndex)
        }
        if otherIndex < incomingElements.endIndex {
            mergedResult.append(contentsOf: incomingElements[otherIndex...])
        }
        return mergedResult
    }
    
    func sortedMerge<Field>(_ incomingElements: [Element], using sorting: [Sort<Field>]) -> [Element] where Element == Field.Model, Element: Identifiable, Field: SortField {
        sortedMerge(incomingElements, by: sorting.areInIncreasingOrder())
    }
    
    /// Removes an element from a sorted array while maintaining the sort order.
    ///
    /// This method efficiently removes an element from a sorted array by first attempting
    /// a binary search for optimal performance. If the binary search fails (e.g., when
    /// sorting parameters have changed), it falls back to a linear search by ID.
    ///
    /// The method preserves the sorted order of the remaining elements and handles
    /// cases where the element might not be found in the array.
    ///
    /// - Parameters:
    ///   - element: The element to remove from the array.
    ///   - sorting: A closure that defines the sort order between two elements.
    ///     The closure should return `true` if the first element should be ordered
    ///     before the second element.
    /// - Complexity: O(log n) average case when binary search succeeds, O(n) worst case
    ///   when falling back to linear search.
    mutating func sortedRemove(_ element: Element, by sorting: (Element, Element) -> Bool) where Element: Identifiable {
        // Binary search succeeds if the element is present and its sorting parameters have not changed.
        if let index = firstSortedIndex(for: element, using: sorting) {
            remove(at: index)
        } else {
            remove(byId: element.id)
        }
    }
    
    /// Removes an element from a sorted array using a collection of sort fields.
    ///
    /// This method is a convenience overload that allows you to specify sorting criteria
    /// using an array of `Sort<Field>` objects instead of a custom sorting closure.
    /// It internally converts the sort fields to a sorting closure and delegates to
    /// the main `sortedRemove(_:by:)` method.
    ///
    /// - Parameters:
    ///   - element: The element to remove from the array.
    ///   - sorting: An array of sort field configurations that define the sort order.
    ///     The sort fields are applied in order, with earlier fields taking precedence.
    /// - Complexity: O(log n) average case when binary search succeeds, O(n) worst case
    ///   when falling back to linear search.
    mutating func sortedRemove<Field>(_ element: Element, using sorting: [Sort<Field>]) where Element == Field.Model, Element: Identifiable, Field: SortField {
        sortedRemove(element, by: sorting.areInIncreasingOrder())
    }
    
    /// Replaces an element in a sorted array while maintaining the sort order.
    ///
    /// This method efficiently replaces an element in a sorted array by first attempting
    /// a binary search for optimal performance. If the binary search fails (e.g., when
    /// sorting parameters have changed), it falls back to a linear search by ID.
    ///
    /// The method preserves the sorted order of the array by:
    /// 1. Finding the existing element using binary search or linear search
    /// 2. Removing the existing element from its current position
    /// 3. Finding the correct insertion position for the new element using binary search
    /// 4. Inserting the new element at the appropriate position to maintain sort order
    ///
    /// - Important: If no element with the specified ID is found, no changes will be made.
    ///   The method will silently return without modifying the array.
    ///
    /// - Parameters:
    ///   - element: The new element to replace the existing one.
    ///   - sorting: A closure that defines the sort order between two elements.
    ///     The closure should return `true` if the first element should be ordered
    ///     before the second element.
    /// - Complexity: O(log n) average case when binary search succeeds, O(n) worst case
    ///   when falling back to linear search.
    /// - Note: This method assumes the array is already sorted according to the provided
    ///   sorting closure. If the array is not sorted, the behavior is undefined.
    mutating func sortedReplace(_ element: Element, by sorting: (Element, Element) -> Bool) where Element: Identifiable {
        let existingIndex: Index? = {
            // Binary search succeeds if the element is present and its sorting parameters have not changed.
            if let index = firstSortedIndex(for: element, using: sorting) {
                return index
            }
            return firstIndex(where: { $0.id == element.id })
        }()
        guard let existingIndex else { return }
        // Element was present, replace it and keep the sorted order
        remove(at: existingIndex)
        let insertionIndex = binarySearchInsertionIndex(for: element, using: sorting)
        insert(element, at: insertionIndex)
    }
    
    /// Replaces an element in a sorted array using a collection of sort fields.
    ///
    /// This method is a convenience overload that allows you to specify sorting criteria
    /// using an array of `Sort<Field>` objects instead of a custom sorting closure.
    /// It internally converts the sort fields to a sorting closure and delegates to
    /// the main `sortedReplace(_:by:)` method.
    ///
    /// - Important: If no element with the specified ID is found, no changes will be made.
    ///   The method will silently return without modifying the array.
    ///
    /// - Parameters:
    ///   - element: The new element to replace the existing one.
    ///   - sorting: An array of sort field configurations that define the sort order.
    ///     The sort fields are applied in order, with earlier fields taking precedence.
    /// - Complexity: O(log n) average case when binary search succeeds, O(n) worst case
    ///   when falling back to linear search.
    /// - Note: This method assumes the array is already sorted according to the provided
    ///   sort fields. If the array is not sorted, the behavior is undefined.
    mutating func sortedReplace<Field>(_ element: Element, using sorting: [Sort<Field>]) where Element == Field.Model, Element: Identifiable, Field: SortField {
        sortedReplace(element, by: sorting.areInIncreasingOrder())
    }
    
    /// Performs a binary search to find an element with the same ID in a sorted array.
    ///
    /// - Important: Only works if sorting parameters have not changed.
    ///
    /// - Parameters:
    ///   - element: The element to search for.
    ///   - sorting: A closure that defines the sort order between two elements.
    /// - Returns: The index of the found element, or nil if not found.
    private func firstSortedIndex(for element: Element, using sorting: (Element, Element) -> Bool) -> Index? where Element: Identifiable {
        var left = startIndex
        var right = endIndex
        while left < right {
            let mid = index(left, offsetBy: distance(from: left / 2, to: right / 2))
            if self[mid].id == element.id {
                return mid
            } else if sorting(self[mid], element) {
                left = index(after: mid)
            } else {
                right = mid
            }
        }
        return nil
    }
    
    /// Performs a binary search to find the insertion index for a new element in a sorted array.
    ///
    /// - Parameters:
    ///   - element: The element to find the insertion index for.
    ///   - sorting: A closure that defines the sort order between two elements.
    /// - Returns: The index where the element should be inserted to maintain the sort order.
    private func binarySearchInsertionIndex(for element: Element, using sorting: (Element, Element) -> Bool) -> Index {
        var left = startIndex
        var right = endIndex
        while left < right {
            let mid = index(left, offsetBy: distance(from: left, to: right) / 2)
            if sorting(self[mid], element) {
                left = index(after: mid)
            } else {
                right = mid
            }
        }
        return left
    }
}

// MARK: - Updating Element's Property

extension Array {
    mutating func updateFirstElement(where predicate: (Element) -> Bool, changes: (inout Element) -> Void) {
        guard let index = firstIndex(where: predicate) else { return }
        var updatedElement = self[index]
        changes(&updatedElement)
        self[index] = updatedElement
    }
}

// MARK: - Nested Updates

extension Array where Element: Identifiable {
    /// Inserts or replaces an element in a nested array structure based on its ID and parent relationship.
    ///
    /// This method handles hierarchical data structures where elements can have parent-child relationships.
    /// If the new element has a parent ID, it will be inserted into the parent's nested collection.
    /// If no parent ID is provided, the element will be inserted at the top level of the array.
    ///
    /// - Parameters:
    ///   - newElement: The element to insert or replace.
    ///   - parentIdKeyPath: A key path to the optional parent ID property of the element.
    ///     This determines whether the element should be nested under a parent.
    ///   - nestingKeyPath: A writable key path to the optional nested collection property.
    ///     This specifies where child elements are stored within each parent element.
    ///
    /// - Note: If an element with the same ID already exists at the appropriate level
    ///   (either top-level or within a parent's nested collection), it will be replaced.
    ///   Otherwise, the new element will be inserted at the beginning of the appropriate collection.
    ///
    /// - Complexity: O(n) where n is the total number of elements in the array and all nested collections.
    mutating func insert(byId newElement: Element, parentId parentIdKeyPath: KeyPath<Element, Element.ID?>, nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>) {
        if let parentId = newElement[keyPath: parentIdKeyPath] {
            self = updated(byId: parentId, nesting: nestingKeyPath, updates: { parent in
                var updatedParent = parent
                var subitems = updatedParent[keyPath: nestingKeyPath] ?? []
                subitems.insert(byId: newElement)
                updatedParent[keyPath: nestingKeyPath] = subitems
                return updatedParent
            })
        } else {
            insert(byId: newElement)
        }
    }
    
    /// Replaces an element in a nested array structure based on its ID.
    ///
    /// This method searches for an element with the specified ID throughout the entire
    /// nested structure and replaces it with the provided updated element. The search
    /// includes both top-level elements and all nested collections.
    ///
    /// - Parameters:
    ///   - updatedElement: The new element to replace the existing one.
    ///   - nestingKeyPath: A writable key path to the optional nested collection property.
    ///     This specifies where child elements are stored within each parent element.
    ///
    /// - Note: If no element with the specified ID is found, no changes will be made.
    ///   The method searches recursively through all nested levels.
    ///
    /// - Complexity: O(n) where n is the total number of elements in the array and all nested collections.
    mutating func replace(byId updatedElement: Element, nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>) {
        self = updated(byId: updatedElement.id, nesting: nestingKeyPath, updates: { _ in updatedElement })
    }
    
    /// Removes an element from a nested array structure based on its ID.
    ///
    /// This method searches for an element with the specified ID throughout the entire
    /// nested structure and removes it. The search includes both top-level elements
    /// and all nested collections at any depth.
    ///
    /// - Parameters:
    ///   - id: The ID of the element to remove.
    ///   - nestingKeyPath: A writable key path to the optional nested collection property.
    ///     This specifies where child elements are stored within each parent element.
    ///
    /// - Note: If no element with the specified ID is found, no changes will be made.
    ///   The method searches recursively through all nested levels and removes the
    ///   first occurrence found.
    ///
    /// - Complexity: O(n) where n is the total number of elements in the array and all nested collections.
    mutating func remove(byId id: Element.ID, nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>) where Element: Identifiable {
        self = updated(byId: id, nesting: nestingKeyPath, updates: { _ in nil })
    }
    
    /// Updates an element in a nested array structure based on its ID using a closure.
    ///
    /// This method searches for an element with the specified ID throughout the entire
    /// nested structure and applies the provided update closure to it. The search
    /// includes both top-level elements and all nested collections at any depth.
    ///
    /// - Parameters:
    ///   - id: The ID of the element to update.
    ///   - nestingKeyPath: A writable key path to the optional nested collection property.
    ///     This specifies where child elements are stored within each parent element.
    ///   - updates: A closure that receives the element to be updated as an `inout` parameter.
    ///     You can modify any properties of the element within this closure.
    ///
    /// - Note: If no element with the specified ID is found, no changes will be made.
    ///   The method searches recursively through all nested levels and updates the
    ///   first occurrence found.
    ///
    /// - Complexity: O(n) where n is the total number of elements in the array and all nested collections.
    mutating func update(byId id: Element.ID, nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>, updates: (inout Element) -> Void) where Element: Identifiable {
        self = updated(byId: id, nesting: nestingKeyPath) { element in
            var updatedElement = element
            updates(&updatedElement)
            return updatedElement
        }
    }
    
    private func updated(byId id: Element.ID, nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>, updates: (Element) -> Element?) -> Self {
        var updatedElements = self
        for (index, element) in updatedElements.enumerated() {
            if element.id == id {
                if let updated = updates(element) {
                    updatedElements[index] = updated
                } else {
                    updatedElements.remove(at: index)
                }
            }
            if let nestedElements = element[keyPath: nestingKeyPath], !nestedElements.isEmpty {
                var updatedElement = element
                updatedElement[keyPath: nestingKeyPath] = nestedElements.updated(byId: id, nesting: nestingKeyPath, updates: updates)
                updatedElements[index] = updatedElement
            }
        }
        return updatedElements
    }
}
