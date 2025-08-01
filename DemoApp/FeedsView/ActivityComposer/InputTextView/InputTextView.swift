//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import UIKit

enum TextSizeConstants {
    static let defaultInputViewHeight: CGFloat = 38.0
    static var minimumHeight: CGFloat {
        38
    }

    static var maximumHeight: CGFloat {
        76
    }

    static var minThreshold: CGFloat {
        38
    }

    static var cornerRadius: CGFloat {
        20
    }
}

class InputTextView: UITextView {
    /// Label used as placeholder for textView when it's empty.
    open private(set) lazy var placeholderLabel: UILabel = UILabel()
        .withoutAutoresizingMaskConstraints

    /// The minimum height of the text view.
    /// When there is no content in the text view OR the height of the content is less than this value,
    /// the text view will be of this height
    open var minimumHeight: CGFloat {
        TextSizeConstants.minimumHeight
    }

    /// The maximum height of the text view.
    /// When the content in the text view is greater than this height, scrolling will be enabled and the text view's height will be restricted to this value
    open var maximumHeight: CGFloat {
        TextSizeConstants.maximumHeight
    }

    override open var text: String! {
        didSet {
            if !oldValue.isEmpty && text.isEmpty {
                textDidChangeProgrammatically()
            }
        }
    }
    
    var onImagePasted: ((UIImage) -> Void)?

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }

        setUp()
        setUpLayout()
        setUpAppearance()
    }

    open func setUp() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTextChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }

    open func setUpAppearance() {
        backgroundColor = .clear
        textContainer.lineFragmentPadding = 8
        textAlignment = .natural
        font = UIFont.systemFont(ofSize: 17)
        
        placeholderLabel.font = font
        placeholderLabel.textAlignment = .center
        placeholderLabel.textColor = .gray
    }

    open func setUpLayout() {
        embed(
            placeholderLabel,
            insets: .init(
                top: .zero,
                leading: directionalLayoutMargins.leading,
                bottom: .zero,
                trailing: .zero
            )
        )
        placeholderLabel.pin(anchors: [.centerY], to: self)
        isScrollEnabled = true
    }

    /// Sets the given text in the current caret position.
    /// In case the caret is selecting a range of text, it replaces that text.
    ///
    /// - Parameter text: A string to replace the text in the caret position.
    open func replaceSelectedText(_ text: String) {
        guard let selectedRange = selectedTextRange else {
            self.text.append(text)
            return
        }

        replace(selectedRange, withText: text)
    }

    open func textDidChangeProgrammatically() {
        delegate?.textViewDidChange?(self)
        handleTextChange()
    }

    @objc open func handleTextChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }

    open func shouldAnimate(_ newText: String) -> Bool {
        abs(newText.count - text.count) < 10
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if TextSizeConstants.defaultInputViewHeight != minimumHeight
            && minimumHeight == frame.size.height {
            let rect = layoutManager.usedRect(for: textContainer)
            let topInset = (frame.size.height - rect.height) / 2.0
            textContainerInset.top = max(0, topInset)
        }
    }

    override open func paste(_ sender: Any?) {
        super.paste(sender)
        if let pastedImage = UIPasteboard.general.image,
           let onImagePasted {
            onImagePasted(pastedImage)
            return
        }
        handleTextChange()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.scrollToBottom()
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) && onImagePasted != nil && UIPasteboard.general.image != nil {
            true
        } else {
            super.canPerformAction(action, withSender: sender)
        }
    }
}
