//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import UIKit

extension UIView {
    // MARK: - `embed` family of helpers

    func embed(_ subview: UIView, insets: NSDirectionalEdgeInsets = .zero) {
        addSubview(subview)

        NSLayoutConstraint.activate([
            subview.leadingAnchor.pin(equalTo: leadingAnchor, constant: insets.leading),
            subview.trailingAnchor.pin(equalTo: trailingAnchor, constant: -insets.trailing),
            subview.topAnchor.pin(equalTo: topAnchor, constant: insets.top),
            subview.bottomAnchor.pin(equalTo: bottomAnchor, constant: -insets.bottom)
        ])
    }

    func pin(anchors: [LayoutAnchorName] = [.top, .leading, .bottom, .trailing], to view: UIView) {
        anchors
            .map { $0.makeConstraint(fromView: self, toView: view) }
            .forEach { $0.isActive = true }
    }

    func pin(anchors: [LayoutAnchorName] = [.top, .leading, .bottom, .trailing], to layoutGuide: UILayoutGuide) {
        anchors
            .compactMap { $0.makeConstraint(fromView: self, toLayoutGuide: layoutGuide) }
            .forEach { $0.isActive = true }
    }

    func pin(anchors: [LayoutAnchorName] = [.width, .height], to constant: CGFloat) {
        anchors
            .compactMap { $0.makeConstraint(fromView: self, constant: constant) }
            .forEach { $0.isActive = true }
    }

    var withoutAutoresizingMaskConstraints: Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    var isVisible: Bool {
        get { !isHidden }
        set { isHidden = !newValue }
    }
}

enum LayoutAnchorName {
    case bottom
    case centerX
    case centerY
    case firstBaseline
    case height
    case lastBaseline
    case leading
    case left
    case right
    case top
    case trailing
    case width

    @MainActor
    func makeConstraint(fromView: UIView, toView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        switch self {
        case .bottom:
            fromView.bottomAnchor.pin(equalTo: toView.bottomAnchor, constant: constant)
        case .centerX:
            fromView.centerXAnchor.pin(equalTo: toView.centerXAnchor, constant: constant)
        case .centerY:
            fromView.centerYAnchor.pin(equalTo: toView.centerYAnchor, constant: constant)
        case .firstBaseline:
            fromView.firstBaselineAnchor.pin(equalTo: toView.firstBaselineAnchor, constant: constant)
        case .height:
            fromView.heightAnchor.pin(equalTo: toView.heightAnchor, constant: constant)
        case .lastBaseline:
            fromView.lastBaselineAnchor.pin(equalTo: toView.lastBaselineAnchor, constant: constant)
        case .leading:
            fromView.leadingAnchor.pin(equalTo: toView.leadingAnchor, constant: constant)
        case .left:
            fromView.leftAnchor.pin(equalTo: toView.leftAnchor, constant: constant)
        case .right:
            fromView.rightAnchor.pin(equalTo: toView.rightAnchor, constant: constant)
        case .top:
            fromView.topAnchor.pin(equalTo: toView.topAnchor, constant: constant)
        case .trailing:
            fromView.trailingAnchor.pin(equalTo: toView.trailingAnchor, constant: constant)
        case .width:
            fromView.widthAnchor.pin(equalTo: toView.widthAnchor, constant: constant)
        }
    }

    @MainActor
    func makeConstraint(fromView: UIView, toLayoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint? {
        switch self {
        case .bottom:
            fromView.bottomAnchor.pin(equalTo: toLayoutGuide.bottomAnchor, constant: constant)
        case .centerX:
            fromView.centerXAnchor.pin(equalTo: toLayoutGuide.centerXAnchor, constant: constant)
        case .centerY:
            fromView.centerYAnchor.pin(equalTo: toLayoutGuide.centerYAnchor, constant: constant)
        case .height:
            fromView.heightAnchor.pin(equalTo: toLayoutGuide.heightAnchor, constant: constant)
        case .leading:
            fromView.leadingAnchor.pin(equalTo: toLayoutGuide.leadingAnchor, constant: constant)
        case .left:
            fromView.leftAnchor.pin(equalTo: toLayoutGuide.leftAnchor, constant: constant)
        case .right:
            fromView.rightAnchor.pin(equalTo: toLayoutGuide.rightAnchor, constant: constant)
        case .top:
            fromView.topAnchor.pin(equalTo: toLayoutGuide.topAnchor, constant: constant)
        case .trailing:
            fromView.trailingAnchor.pin(equalTo: toLayoutGuide.trailingAnchor, constant: constant)
        case .width:
            fromView.widthAnchor.pin(equalTo: toLayoutGuide.widthAnchor, constant: constant)
        case .firstBaseline, .lastBaseline:
            // TODO: Log warning? Error?
            nil
        }
    }

    @MainActor
    func makeConstraint(fromView: UIView, constant: CGFloat) -> NSLayoutConstraint? {
        switch self {
        case .height:
            fromView.heightAnchor.pin(equalToConstant: constant)
        case .width:
            fromView.widthAnchor.pin(equalToConstant: constant)
        default:
            // TODO: Log warning? Error?
            nil
        }
    }
}

extension UIView {
    /// According to this property, you can differ whether the current language is `rightToLeft`
    /// and setup actions according to it.
    var currentLanguageIsRightToLeftDirection: Bool {
        traitCollection.layoutDirection == .rightToLeft
    }
}
