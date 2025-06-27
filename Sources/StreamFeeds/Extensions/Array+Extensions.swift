//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

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
    /// - Parameter element: The element to remove.
    mutating func remove(byId element: Element) where Element: Identifiable {
        guard let index = firstIndex(where: { $0.id == element.id }) else { return }
        remove(at: index)
    }
    
    /// Replaces an element from the non-sorted array based on its ID.
    ///
    /// - Parameter element: The new element for replacing the existing one.
    mutating func replace(byId element: Element) where Element: Identifiable {
        guard let index = firstIndex(where: { $0.id == element.id }) else { return }
        replaceSubrange(index...index, with: CollectionOfOne(element))
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
            let nextIndex = self.index(insertionIndex, offsetBy: distance)
            if nextIndex < endIndex, self[nextIndex].id == element.id {
                remove(at: nextIndex)
                break
            }
            let previousIndex = self.index(insertionIndex, offsetBy: -distance)
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
                currentIndex = self.index(after: currentIndex)
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
            currentIndex = self.index(after: currentIndex)
        }
        if otherIndex < incomingElements.endIndex {
            mergedResult.append(contentsOf: incomingElements[otherIndex...])
        }
        return mergedResult
    }
    
    func sortedMerge<Field>(_ incomingElements: [Element], using sorting: [Sort<Field>]) -> [Element] where Element == Field.Model, Element: Identifiable, Field: SortField {
        sortedMerge(incomingElements, by: sorting.areInIncreasingOrder())
    }
    
    /// Removes an element from the sorted array based on its ID.
    ///
    /// At first it tries to use binary search, but if it fails, does a linear lookup.
    ///
    /// - Parameters:
    ///   - element: The element to remove.
    ///   - sorting: A closure that defines the sort order between two elements.
    mutating func sortedRemove(_ element: Element, by sorting: (Element, Element) -> Bool) where Element: Identifiable {
        // Binary search succeeds if the element is present and its sorting parameters have not changed.
        if let index = firstSortedIndex(for: element, using: sorting) {
            remove(at: index)
        } else {
            remove(byId: element)
        }
    }
    
    mutating func sortedRemove<Field>(_ element: Element, using sorting: [Sort<Field>]) where Element == Field.Model, Element: Identifiable, Field: SortField {
        sortedRemove(element, by: sorting.areInIncreasingOrder())
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
            let mid = index(left, offsetBy: distance(from: left , to: right) / 2)
            if sorting(self[mid], element) {
                left = index(after: mid)
            } else {
                right = mid
            }
        }
        return left
    }
}

// MARK: - Sorting

extension Array {
    func sorted<Field>(using sorting: [Sort<Field>]) -> [Element] where Field: SortField, Element == Field.Model {
        sorted(by: { lhs, rhs in
            for sort in sorting {
                let result = sort.compare(lhs, rhs)
                switch result {
                case .orderedSame:
                    continue
                case .orderedAscending:
                    return true
                case .orderedDescending:
                    return false
                }
            }
            return false
        })
    }
}
