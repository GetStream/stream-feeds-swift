//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import SwiftUI

private struct OnLoadViewModifier: ViewModifier {
    @State private var hasLoaded = false
    
    let action: (() -> Void)
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasLoaded else { return }
                action()
                hasLoaded = true
            }
    }
}

private struct AsyncOnLoadViewModifier: ViewModifier {
    @State var hasPrepared = false
    @State var task: Task<Void, Never>?
    
    let action: (() async -> Void)
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasPrepared else { return }
                guard task == nil else { return }
                task = Task {
                    await action()
                    hasPrepared = true
                }
            }
            .onDisappear {
                task?.cancel()
                task = nil
            }
    }
}

extension View {
    func onLoad(perform action: @escaping () -> Void) -> some View {
        modifier(OnLoadViewModifier(action: action))
    }
    
    func onLoad(perform action: @escaping () async -> Void) -> some View {
        modifier(AsyncOnLoadViewModifier(action: action))
    }
}
