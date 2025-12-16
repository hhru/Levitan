#if canImport(UIKit)
import Foundation

internal final class TextLayoutProvider: Sendable {

    internal func textContext(
        for content: Text,
        context: ComponentContext
    ) -> TextContext {
        let typography = content.typography ?? context.textTypography

        let decoration = context
            .textDecoration
            .appending(contentsOf: content.decoration)

        let animation = content.animation ?? context.textAnimation
        let isEnabled = content.isEnabled && context.isEnabled

        return TextContext(
            typography: typography,
            decoration: decoration,
            animation: animation,
            isEnabled: isEnabled,
            isHovered: false,
            isPressed: false,
            tokenTheme: context.tokenTheme
        )
    }

    internal func textLayout(
        for content: Text,
        context: TextContext,
        hoveredPartIndex: Int? = nil,
        pressedPartIndex: Int? = nil,
        cache: TextCache? = nil
    ) -> TextLayout {
        let key = TextCacheKey(
            content: content,
            context: context,
            hoveredPartIndex: hoveredPartIndex,
            pressedPartIndex: pressedPartIndex
        )

        if let layout = cache?.restoreLayout(for: key) {
            return layout
        }

        let attributedText = NSMutableAttributedString()
        var partThresholds: [Int] = []

        for part in content.parts.enumerated() {
            let partContext = context
                .hovered(part.offset == hoveredPartIndex)
                .pressed(part.offset == pressedPartIndex)

            let partAttributedText = part
                .element
                .attributedText(context: partContext)

            attributedText.append(partAttributedText)
            partThresholds.append(attributedText.length)
        }

        let layout = TextLayout(
            attributedText: attributedText,
            partThresholds: partThresholds
        )

        cache?.storeLayout(layout, for: key)

        return layout
    }
}

extension TextLayoutProvider {

    internal static let shared = TextLayoutProvider()
}
#endif
