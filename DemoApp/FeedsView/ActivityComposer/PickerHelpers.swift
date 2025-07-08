//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import SwiftUI

public struct VideoIndicatorView: View {

    public init() {}

    public var body: some View {
        BottomLeftView {
            Image(systemName: "video.fill")
                .customizable()
                .frame(width: 22)
                .padding(2)
                .applyDefaultIconOverlayStyle()
                .modifier(ShadowModifier())
        }
    }
}

/// View displaying the duration of the video.
public struct VideoDurationIndicatorView: View {
    var colors = Colors.shared

    var duration: String

    public init(duration: String) {
        self.duration = duration
    }

    public var body: some View {
        BottomRightView {
            Text(duration)
                .foregroundColor(Color(colors.staticColorText))
                .font(.footnote)
                .bold()
                .padding(.all, 4)
                .modifier(ShadowModifier())
        }
    }
}

/// View container that allows injecting another view in its bottom right corner.
public struct BottomRightView<Content: View>: View {
    var content: () -> Content

    public init(content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                content()
            }
        }
    }
}

/// View container that allows injecting another view in its bottom left corner.
public struct BottomLeftView<Content: View>: View {
    var content: () -> Content

    public init(content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack {
            VStack {
                Spacer()
                content()
            }
            Spacer()
        }
    }
}

/// View container that allows injecting another view in its top right corner.
public struct TopRightView<Content: View>: View {
    var content: () -> Content

    public init(content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack {
            Spacer()
            VStack {
                content()
                Spacer()
            }
        }
    }
}

/// Modifier for adding shadow to a view.
public struct ShadowModifier: ViewModifier {
    public init(
        firstRadius: CGFloat = 10,
        firstY: CGFloat = 12
    ) {
        self.firstRadius = firstRadius
        self.firstY = firstY
    }
    
    var firstRadius: CGFloat
    var firstY: CGFloat

    public func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.1), radius: firstRadius, x: 0, y: firstY)
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
}

extension Image {
    public func customizable() -> some View {
        renderingMode(.template)
            .resizable()
            .scaledToFit()
    }
}

extension View {
    public func applyDefaultIconOverlayStyle() -> some View {
        modifier(IconOverImageModifier())
    }
}

struct IconOverImageModifier: ViewModifier {
    var colors = Colors.shared

    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(colors.staticColorText))
            .padding(.all, 4)
    }
}

extension UIImage {
    func saveAsJpgToTemporaryUrl() throws -> URL? {
        guard let imageData = jpegData(compressionQuality: 1.0) else { return nil }
        let imageName = "\(UUID().uuidString).jpg"
        let documentDirectory = NSTemporaryDirectory()
        let localPath = documentDirectory.appending(imageName)
        let photoURL = URL(fileURLWithPath: localPath)
        try imageData.write(to: photoURL)
        return photoURL
    }
}
