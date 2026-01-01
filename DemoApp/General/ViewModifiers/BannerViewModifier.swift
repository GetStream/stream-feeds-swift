//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import SwiftUI

private struct ErrorBanner: View {
    let message: String
    @Binding var presented: Bool
    
    init(message: String, isPresented: Binding<Bool>) {
        self.message = message
        _presented = isPresented
    }
    
    var body: some View {
        HStack {
            Text(message)
                .foregroundColor(.white)
                .font(.footnote)
                .lineLimit(3)
            Spacer()
        }
        .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        .background(Color.red)
        .cornerRadius(8)
        .shadow(radius: 4)
        .onAppear {
            Task {
                try await Task.sleep(nanoseconds: .init(3_000_000_000))
                withAnimation(.easeInOut(duration: 0.3)) {
                    presented = false
                }
            }
        }
    }
}

private struct BannerModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            if isPresented {
                VStack {
                    ErrorBanner(message: message, isPresented: $isPresented)
                        .padding()
                    Spacer()
                }
            }
        }
    }
}

extension View {
    func errorBanner(isPresented: Binding<Bool>, message: String) -> some View {
        modifier(BannerModifier(isPresented: isPresented, message: message))
    }
    
    func errorBanner(for activeError: Binding<Error?>) -> some View {
        let isPresented = Binding<Bool> {
            activeError.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                activeError.wrappedValue = nil
            }
        }
        let message = activeError.wrappedValue?.localizedDescription ?? ""
        return modifier(BannerModifier(isPresented: isPresented, message: message))
    }
}

#Preview {
    NavigationView {
        Text("Content")
            .errorBanner(isPresented: .constant(true), message: "This is an error message")
    }
}
