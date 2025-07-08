//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import SwiftUI

private struct ScrollViewPaginationViewModifier: ViewModifier {
    let coordinateSpace: CoordinateSpace
    let threshold: CGFloat
    let onBottomThreshold: () async -> Void
    @State private var lastScrollArea: ScrollArea = .content
    @State private var loading = false
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onChange(of: geometry.frame(in: coordinateSpace)) { _ in
                            handleGeometryChanged(geometry)
                        }
                }
            )
            .task(id: lastScrollArea) {
                await onBottomThreshold()
                loading = false
            }
    }
    
    func handleGeometryChanged(_ geometry: GeometryProxy) {
        guard !loading else { return }
        
        let scrollArea: ScrollArea = {
            let frame = geometry.frame(in: coordinateSpace)
            guard frame.size.height > 0 else { return .content }
            let offset = -frame.minY
            if offset + UIScreen.main.bounds.height + threshold > frame.height {
                return .threshold
            } else {
                return .content
            }
        }()
        // Trigger loading only when scrolling area changes (entering/exiting threshold)
        if scrollArea != lastScrollArea {
            loading = true
            lastScrollArea = scrollArea
        }
    }
}

extension ScrollViewPaginationViewModifier {
    enum PaginationState: Equatable {
        case idle, loading, scheduled
    }

    enum ScrollArea: Equatable {
        case content
        case threshold
    }
}

extension View {
    /// Sets pagination callbacks that will be triggered when the scroll view reaches to pagination thresholds.
    /// These callbacks should be applied to the content view of the `ScrollView`.
    ///
    /// - Important: This modifier must be applied to the content view of the `ScrollView`.
    /// For example:
    /// ```swift
    /// ScrollView {
    ///     LazyVStack {
    ///         // Your content here
    ///     }
    ///     .onScrollPaginationChanged { isNearBottom in
    ///         // Handle pagination
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter action: A closure that takes a boolean parameter indicating whether the scroll view is near the bottom.
    func onScrollPaginationChanged(
        in coordinateSpace: CoordinateSpace = .global,
        threshold: CGFloat = 400,
        onBottomThreshold: @escaping () async -> Void
    ) -> some View {
        modifier(
            ScrollViewPaginationViewModifier(
                coordinateSpace: coordinateSpace,
                threshold: threshold,
                onBottomThreshold: onBottomThreshold
            )
        )
    }
}
