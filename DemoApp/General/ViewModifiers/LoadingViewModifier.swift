//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI

private struct LoadingViewModifier: ViewModifier {
    let loading: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if loading {
                    ProgressView()
                }
            }
    }
}

extension View {
    func loadingContent(isLoading: Bool) -> some View {
        modifier(LoadingViewModifier(loading: isLoading))
    }
}

#Preview {
    NavigationView {
        List {
            Text("Content")
        }
        .loadingContent(isLoading: true)
    }
}
