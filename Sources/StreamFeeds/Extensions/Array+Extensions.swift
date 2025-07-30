//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

// MARK: - Managing Identifiable Elements in Array Without Sorting

extension Array {
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
    
    /// Removes an element from the array based on its ID, optionally searching nested elements.
    ///
    /// - Parameter id: The ID of the element to remove.
    /// - Parameter nesting: Optional key path to search for nested elements.
    mutating func remove(
        byId id: Element.ID,
        nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>? = nil
    ) where Element: Identifiable {
        _unsortedUpdate(ofId: id, nesting: nestingKeyPath, changes: { _ in nil })
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
}

// MARK: - Managing Identifiable Elements in Sorted Array

extension Array where Element: Identifiable {
    /// Inserts an element into a sorted array at the correct position and removes any duplicates.
    ///
    /// - Parameter element: The element to insert.
    /// - Parameter sorting: Closure that defines the sorting order.
    mutating func sortedInsert(_ element: Element, sorting: (Element, Element) -> Bool) {
        let insertionIndex = binarySearchInsertionIndex(for: element, sorting: sorting)
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
    
    /// Inserts an element into a sorted array using SortField configuration.
    ///
    /// - Parameter element: The element to insert.
    /// - Parameter sorting: Array of sort fields that define the sorting order.
    mutating func sortedInsert<Field>(_ element: Element, sorting: [Sort<Field>]) where Element == Field.Model, Field: SortField {
        sortedInsert(element, sorting: sorting.areInIncreasingOrder())
    }
    
    /// Merges incoming elements with the current sorted array, preferring incoming elements over existing ones.
    ///
    /// - Parameter incomingElements: The elements to merge with the current array.
    /// - Parameter areInIncreasingOrder: Closure that defines the sorting order.
    /// - Returns: A new sorted array containing the merged elements.
    func sortedMerge(_ incomingElements: [Element], sorting areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
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
    
    /// Merges incoming elements with the current sorted array using SortField configuration.
    ///
    /// - Parameter incomingElements: The elements to merge with the current array.
    /// - Parameter sorting: Array of sort fields that define the sorting order.
    /// - Returns: A new sorted array containing the merged elements.
    func sortedMerge<Field>(_ incomingElements: [Element], sorting: [Sort<Field>]) -> [Element] where Element == Field.Model, Field: SortField {
        sortedMerge(incomingElements, sorting: sorting.areInIncreasingOrder())
    }
    
    /// Removes an element from a sorted array using SortField configuration, optionally searching nested elements.
    ///
    /// - Parameter matchingElement: The element to remove.
    /// - Parameter nesting: Optional key path to search for nested elements.
    /// - Parameter sorting: Array of sort fields that define the sorting order.
    mutating func sortedRemove<Field>(
        _ matchingElement: Element,
        nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>?,
        sorting: [Sort<Field>]
    ) where Element == Field.Model, Field: SortField {
        sortedRemove(matchingElement, nesting: nestingKeyPath, sorting: sorting.areInIncreasingOrder())
    }
    
    /// Removes an element from a sorted array, optionally searching nested elements.
    ///
    /// - Parameter matchingElement: The element to remove.
    /// - Parameter nesting: Optional key path to search for nested elements.
    /// - Parameter sorting: Closure that defines the sorting order.
    mutating func sortedRemove(
        _ matchingElement: Element,
        nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>?,
        sorting: (Element, Element) -> Bool
    ) {
        _sortedUpdate(
            searchStrategy: .binarySearch(matchingElement),
            nesting: nestingKeyPath,
            sorting: sorting,
            changes: { _ in nil }
        )
    }
    
    /// Replaces an element in a sorted array using SortField configuration, optionally searching nested elements.
    ///
    /// - Parameter matchingElement: The element to replace with.
    /// - Parameter nesting: Optional key path to search for nested elements.
    /// - Parameter sorting: Array of sort fields that define the sorting order.
    mutating func sortedReplace<Field>(
        _ matchingElement: Element,
        nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>?,
        sorting: [Sort<Field>]
    ) where Element == Field.Model, Field: SortField {
        sortedReplace(
            matchingElement,
            nesting: nestingKeyPath,
            sorting: sorting.areInIncreasingOrder()
        )
    }
    
    /// Replaces an element in a sorted array, optionally searching nested elements.
    ///
    /// - Parameter matchingElement: The element to replace with.
    /// - Parameter nesting: Optional key path to search for nested elements.
    /// - Parameter sorting: Closure that defines the sorting order.
    mutating func sortedReplace(
        _ matchingElement: Element,
        nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>?,
        sorting: (Element, Element) -> Bool
    ) {
        _sortedUpdate(
            searchStrategy: .binarySearch(matchingElement),
            nesting: nestingKeyPath,
            sorting: sorting,
            changes: { _ in matchingElement }
        )
    }

    /// Updates an element in a sorted array using a closure, optionally searching nested elements.
    ///
    /// - Parameter matchingElement: The element to update.
    /// - Parameter nesting: Optional key path to search for nested elements.
    /// - Parameter sorting: Closure that defines the sorting order.
    /// - Parameter changes: Closure that modifies the element.
    mutating func sortedUpdate(
        _ matchingElement: Element,
        nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>?,
        sorting: (Element, Element) -> Bool,
        changes: (inout Element) -> Void
    ) {
        _sortedUpdate(
            searchStrategy: .binarySearch(matchingElement),
            nesting: nestingKeyPath,
            sorting: sorting,
            changes: { matchingElement in
                var updatedElement = matchingElement
                changes(&updatedElement)
                return updatedElement
            }
        )
    }
    
    /// Updates an element in a sorted array by ID using a closure, optionally searching nested elements.
    ///
    /// - Parameter matchingId: The ID of the element to update.
    /// - Parameter nesting: Optional key path to search for nested elements.
    /// - Parameter sorting: Closure that defines the sorting order.
    /// - Parameter changes: Closure that modifies the element.
    mutating func sortedUpdate(
        ofId matchingId: Element.ID,
        nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>?,
        sorting: (Element, Element) -> Bool,
        changes: (inout Element) -> Void
    ) {
        _sortedUpdate(
            searchStrategy: .linear(matchingId),
            nesting: nestingKeyPath,
            sorting: sorting,
            changes: { matchingElement in
                var updatedElement = matchingElement
                changes(&updatedElement)
                return updatedElement
            }
        )
    }
    
    private enum ElementSearch {
        case linear(Element.ID)
        case binarySearch(Element)
    }
    
    @discardableResult private mutating func _sortedUpdate(
        searchStrategy: ElementSearch,
        nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>?,
        sorting: (Element, Element) -> Bool,
        changes: (Element) -> Element?
    ) -> Bool {
        var foundMatch = false
        var updatedElements = self
        
        let matchingIndex: Index? = {
            switch searchStrategy {
            case .linear(let matchingId):
                return updatedElements.firstIndex(where: { $0.id == matchingId })
            case .binarySearch(let matchingElement):
                // Here we are looking for existing element which might have a different state
                // therefore if binary search fails, we still need to do linear search.
                if let index = firstSortedIndex(for: matchingElement, sorting: sorting) {
                    return index
                }
                return updatedElements.firstIndex(where: { $0.id == matchingElement.id })
            }
        }()
        if let matchingIndex {
            let element = updatedElements[matchingIndex]
            if let updated = changes(element) {
                updatedElements[matchingIndex] = updated
                // Sort the whole array for simplicity because updating can change the sorting
                updatedElements.sort(by: sorting)
            } else {
                // Nil means remove
                updatedElements.remove(at: matchingIndex)
            }
            foundMatch = true
        } else if let nestingKeyPath {
            // Try nested paths of each element until match is found
            for (index, element) in updatedElements.enumerated() {
                if var nestedElements = element[keyPath: nestingKeyPath], !nestedElements.isEmpty {
                    foundMatch = nestedElements._sortedUpdate(searchStrategy: searchStrategy, nesting: nestingKeyPath, sorting: sorting, changes: changes)
                    if foundMatch {
                        var updatedElement = element
                        updatedElement[keyPath: nestingKeyPath] = nestedElements
                        updatedElements[index] = updatedElement
                        break // duplicates are not expected
                    }
                }
            }
        }
        if foundMatch {
            self = updatedElements
        }
        return foundMatch
    }
    
    @discardableResult private mutating func _unsortedUpdate(
        ofId id: Element.ID,
        nesting nestingKeyPath: WritableKeyPath<Element, [Element]?>?,
        changes: (Element) -> Element?
    ) -> Bool {
        _sortedUpdate(searchStrategy: .linear(id), nesting: nestingKeyPath, sorting: { _, _ in true }, changes: changes)
    }
    
    private func firstSortedIndex(for element: Element, sorting: (Element, Element) -> Bool) -> Index? {
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
    
    private func binarySearchInsertionIndex(for element: Element, sorting: (Element, Element) -> Bool) -> Index {
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
    /// Updates the first element that matches the predicate using a closure.
    ///
    /// - Parameter predicate: Closure that determines which element to update.
    /// - Parameter changes: Closure that modifies the element.
    mutating func updateFirstElement(where predicate: (Element) -> Bool, changes: (inout Element) -> Void) {
        guard let index = firstIndex(where: predicate) else { return }
        var updatedElement = self[index]
        changes(&updatedElement)
        self[index] = updatedElement
    }
}
