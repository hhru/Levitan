import UIKit

public final class TextView: UILabel {

    private var content: Text?
    private var context: ComponentContext?

    private var partThresholds: [Int] = []

    private var hoveredPartIndex: Int?
    private var pressedPartIndex: Int?
    private var animatedPartIndex: Int?

    private var hasTapAction = false

    public override init(frame: CGRect) {
        super.init(frame: frame)

        tokens.customBinding { view, theme in
            view.updateAttributedText(theme: theme)
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateAttributedText(theme: TokenTheme) {
        let context = context?
            .tokenThemeKey(theme.key)
            .tokenThemeScheme(theme.scheme)

        guard let content, let context else {
            return
        }

        let attributedText = NSMutableAttributedString()

        partThresholds.removeAll(keepingCapacity: true)

        for (partIndex, part) in content.parts.enumerated() {
            let partState = TextPartState(
                isHovered: partIndex == hoveredPartIndex,
                isPressed: partIndex == pressedPartIndex
            )

            let partAttributedText = part.attributedText(
                context: context.textPartState(partState)
            )

            attributedText.append(partAttributedText)
            partThresholds.append(attributedText.length)
        }

        self.attributedText = attributedText
    }

    private func updateAttributedText() {
        updateAttributedText(theme: tokens.theme)
    }

    private func animatePressedPart() {
        animatedPartIndex = pressedPartIndex

        let animation = content?.animation ?? context?.textAnimation

        let partAnimation = pressedPartIndex == nil
            ? animation?.unpress
            : animation?.press

        guard let partAnimation else {
            return updateAttributedText()
        }

        let transition = partAnimation
            .caTransition
            .resolve(for: tokens.theme)

        transition.delegate = self

        layer.add(
            transition,
            forKey: "text"
        )

        updateAttributedText()
    }

    private func updatePressedPart(index: Int?) {
        guard pressedPartIndex != index else {
            return
        }

        pressedPartIndex = index

        let isAnimating = layer.animationKeys()?.contains { key in
            layer.animation(forKey: key)?.delegate === self
        } ?? false

        if isAnimating {
            updateAttributedText()
        } else {
            animatePressedPart()
        }
    }

    private func touchCharacterIndex(touchLocation: CGPoint) -> Int? {
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

        let touchTextLocation = CGPoint(
            x: touchLocation.x - textOffset.x,
            y: touchLocation.y - textOffset.y
        )

        return layoutManager.characterIndex(
            for: touchTextLocation,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
    }

    private func touchPartIndex(touch: UITouch) -> Int? {
        let touchLocation = touch.location(in: self)

        guard bounds.contains(touchLocation) else {
            return nil
        }

        guard let characterIndex = touchCharacterIndex(touchLocation: touchLocation) else {
            return nil
        }

        guard let partIndex = partThresholds.firstIndex(where: { $0 > characterIndex }) else {
            return nil
        }

        return content?.parts[partIndex].isEnabled == true
            ? partIndex
            : nil
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let previousContentSizeCategory = previousTraitCollection?.preferredContentSizeCategory
        let contentSizeCategory = traitCollection.preferredContentSizeCategory

        if previousContentSizeCategory != contentSizeCategory {
            updateAttributedText()
        }
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let touch = touches.first, hasTapAction else {
            return
        }

        updatePressedPart(index: touchPartIndex(touch: touch))
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard let touch = touches.first, hasTapAction else {
            return updatePressedPart(index: nil)
        }

        updatePressedPart(index: touchPartIndex(touch: touch))
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isUserInteractionEnabled = self.context?.isEnabled ?? true

            partTapAction?()
            content.tapAction?()
        }
    }
}

extension TextView: CAAnimationDelegate {

    public func animationDidStop(_ animation: CAAnimation, finished: Bool) {
        if animatedPartIndex != pressedPartIndex {
            animatePressedPart()
        }
    }
}

extension TextView: FallbackComponentView {

    public static func sizing(
        for content: Text,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        let size = Self.size(
            for: content,
            fitting: size,
            context: context
        )

        return ComponentSizing(size: size)
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

        hoveredPartIndex = nil
        pressedPartIndex = nil
        animatedPartIndex = nil

        if content.tapAction == nil {
            hasTapAction = content
                .parts
                .contains { $0.tapAction != nil && $0.isEnabled }
        } else {
            hasTapAction = true
        }

        updateAttributedText()

        isUserInteractionEnabled = context.isEnabled
        numberOfLines = context.lineLimit ?? .zero
        lineBreakMode = content.lineBreakMode
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
                context: context.textPartState(.default)
            )

            attributedText.append(partAttributedText)
        }

        return attributedText
    }

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
            lineLimit: context.lineLimit,
            lineBreakMode: content.lineBreakMode
        )
    }
}
