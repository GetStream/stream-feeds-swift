//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct AsyncButton<Label>: View where Label: View & Sendable {
    let action: () async -> Void
    @ViewBuilder let label: () -> Label

    init(
        action: @escaping () async -> Void,
        label: @escaping () -> Label
    ) {
        self.action = action
        self.label = label
    }

    @State private var isLoading = false

    var body: some View {
        Button {
            isLoading = true
            Task {
                await action()
                isLoading = false
            }
        } label: {
            HStack {
                label()
                if isLoading {
                    Spacer()
                    ProgressView()
                }
            }
            
        }
        .disabled(isLoading)
    }
}

#Preview {
    AsyncButton {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
    } label: {
        Image(systemName: "hammer")
    }
}
