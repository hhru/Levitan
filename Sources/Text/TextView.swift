#if canImport(UIKit)
import UIKit

public final class TextView: UILabel {

    private var content: Text?
    private var context: ComponentContext?

    private var partThresholds: [Int] = []

    private var hoveredPartIndex: Int?
    private var pressedPartIndex: Int?

    private var hasTapAction = false

    private lazy var operationQueue: TextOperationQueue = {
        TextOperationQueue(layer: layer)
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        #if os(iOS)
        let hoverGestureRecognizer = UIHoverGestureRecognizer(
            target: self,
            action: #selector(onHoverGesture(recognizer:))
        )

        addGestureRecognizer(hoverGestureRecognizer)
        #endif

        tokens.customBinding { view, theme in
            view.updateAttributedText(
                hoveredPartIndex: view.hoveredPartIndex,
                pressedPartIndex: view.pressedPartIndex,
                theme: theme
            )
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateAttributedText(hoveredPartIndex: Int?, pressedPartIndex: Int?, theme: TokenTheme) {
        let context = context?
            .tokenThemeKey(theme.key)
            .tokenThemeScheme(theme.scheme)

        guard let content, let context else {
            return
        }

        let attributedText = NSMutableAttributedString()

        partThresholds.removeAll(keepingCapacity: true)

        for (partIndex, part) in content.parts.enumerated() {
            let partContext = context
                .isTextPartHovered(partIndex == hoveredPartIndex)
                .isTextPartPressed(partIndex == pressedPartIndex)

            let partAttributedText = part.attributedText(context: partContext)

            attributedText.append(partAttributedText)
            partThresholds.append(attributedText.length)
        }

        self.attributedText = attributedText

        numberOfLines = context.lineLimit ?? .zero
        lineBreakMode = content.lineBreakMode
    }

    private func updateAttributedText(hoveredPartIndex: Int?, pressedPartIndex: Int?) {
        updateAttributedText(
            hoveredPartIndex: hoveredPartIndex,
            pressedPartIndex: pressedPartIndex,
            theme: tokens.theme
        )
    }

    private func updateAttributedText() {
        let hoveredPartIndex = hoveredPartIndex
        let pressedPartIndex = pressedPartIndex

        let animation = content?.animation ?? context?.textAnimation

        let updateAnimation = attributedText != nil && window != nil
            ? animation?.update
            : nil

        operationQueue.addOperation(animation: updateAnimation) {
            self.updateAttributedText(
                hoveredPartIndex: hoveredPartIndex,
                pressedPartIndex: pressedPartIndex
            )
        }
    }

    private func updateHoveredPart(index: Int?) {
        guard hoveredPartIndex != index else {
            return
        }

        hoveredPartIndex = index

        let hoveredPartIndex = hoveredPartIndex
        let pressedPartIndex = pressedPartIndex

        let animation = content?.animation ?? context?.textAnimation

        let partAnimation = pressedPartIndex == nil
            ? (window == nil ? nil : animation?.unhover)
            : (window == nil ? nil : animation?.hover)

        operationQueue.addOperation(animation: partAnimation) {
            self.updateAttributedText(
                hoveredPartIndex: hoveredPartIndex,
                pressedPartIndex: pressedPartIndex
            )
        }
    }

    private func updatePressedPart(index: Int?) {
        guard pressedPartIndex != index else {
            return
        }

        pressedPartIndex = index

        let hoveredPartIndex = hoveredPartIndex
        let pressedPartIndex = pressedPartIndex

        let animation = content?.animation ?? context?.textAnimation

        let partAnimation = pressedPartIndex == nil
            ? (window == nil ? nil : animation?.unpress)
            : (window == nil ? nil : animation?.press)

        operationQueue.addOperation(animation: partAnimation) {
            self.updateAttributedText(
                hoveredPartIndex: hoveredPartIndex,
                pressedPartIndex: pressedPartIndex
            )
        }
    }

    private func gestureCharacterIndex(location: CGPoint) -> Int? {
        guard let attributedText else {
            return nil
        }

        let size = bounds.size

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: size)
        let textStorage = NSTextStorage(attributedString: attributedText)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = .zero

        let textBounds = layoutManager.usedRect(for: textContainer)

        let textOffset = CGPoint(
            x: 0.5 * (size.width - textBounds.size.width) - textBounds.origin.x,
            y: 0.5 * (size.height - textBounds.size.height) - textBounds.origin.y
        )

        let gestureTextLocation = CGPoint(
            x: location.x - textOffset.x,
            y: location.y - textOffset.y
        )

        return layoutManager.characterIndex(
            for: gestureTextLocation,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
    }

    private func gesturePartIndex(location: CGPoint) -> Int? {
        guard bounds.contains(location) else {
            return nil
        }

        guard let characterIndex = gestureCharacterIndex(location: location) else {
            return nil
        }

        guard let partIndex = partThresholds.firstIndex(where: { $0 > characterIndex }) else {
            return nil
        }

        return content?.parts[partIndex].isEnabled == true
            ? partIndex
            : nil
    }

    #if os(iOS)
    @objc
    private func onHoverGesture(recognizer: UIHoverGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            updateHoveredPart(index: gesturePartIndex(location: recognizer.location(in: self)))

        case .ended, .cancelled, .failed, .possible:
            updateHoveredPart(index: nil)

        @unknown default:
            updateHoveredPart(index: nil)
        }
    }
    #endif

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let previousContentSizeCategory = previousTraitCollection?.preferredContentSizeCategory
        let contentSizeCategory = traitCollection.preferredContentSizeCategory

        if previousContentSizeCategory != contentSizeCategory {
            if !operationQueue.isRunning {
                updateAttributedText()
            }
        }
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let touch = touches.first, hasTapAction else {
            return
        }

        updatePressedPart(index: gesturePartIndex(location: touch.location(in: self)))
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard let touch = touches.first, hasTapAction else {
            return updatePressedPart(index: nil)
        }

        updatePressedPart(index: gesturePartIndex(location: touch.location(in: self)))
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        updatePressedPart(index: nil)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        guard let content else {
            return
        }

        let partTapAction = pressedPartIndex.flatMap { partIndex in
            content.parts[safe: partIndex]?.tapAction
        }

        updatePressedPart(index: nil)

        guard let touch = touches.first, bounds.contains(touch.location(in: self)) else {
            return
        }

        guard partTapAction != nil || content.tapAction != nil else {
            return
        }

        isUserInteractionEnabled = false

        operationQueue.addOperation {
            self.isUserInteractionEnabled = self.context?.isEnabled ?? true

            partTapAction?()
            content.tapAction?()
        }
    }
}

extension TextView: FallbackManualComponentView {

    public static func size(
        for content: Text,
        fitting size: CGSize,
        context: ComponentContext
    ) -> CGSize {
        let attributedText = attributedText(
            for: content,
            context: context
        )

        return attributedText.size(
            fitting: size,
            lineLimit: content.lineLimit,
            lineBreakMode: content.lineBreakMode
        )
    }

    public func update(with content: Text, context: ComponentContext) {
        let typography = content.typography ?? context.textTypography

        let decoration = context
            .textDecoration
            .appending(contentsOf: content.decoration)

        let animation = content.animation ?? context.textAnimation

        let context = context
            .textTypography(typography)
            .textDecoration(decoration)
            .textAnimation(animation)
            .lineLimit(content.lineLimit)
            .disabled(!content.isEnabled)

        self.content = content
        self.context = context

        isUserInteractionEnabled = context.isEnabled

        hoveredPartIndex = nil
        pressedPartIndex = nil

        if content.tapAction == nil {
            hasTapAction = content
                .parts
                .contains { $0.tapAction != nil && $0.isEnabled }
        } else {
            hasTapAction = true
        }

        updateAttributedText()

        sizeToFit()
    }
}

extension TextView {

    public static func attributedText(
        for content: Text,
        context: ComponentContext
    ) -> NSAttributedString {
        let typography = content.typography ?? context.textTypography

        let decoration = context
            .textDecoration
            .appending(contentsOf: content.decoration)

        let animation = content.animation ?? context.textAnimation

        let context = context
            .textTypography(typography)
            .textDecoration(decoration)
            .textAnimation(animation)
            .lineLimit(content.lineLimit)
            .disabled(!content.isEnabled)

        let attributedText = NSMutableAttributedString()

        for part in content.parts {
            let partAttributedText = part.attributedText(
                context: context
            )

            attributedText.append(partAttributedText)
        }

        return attributedText
    }
}
#endif
