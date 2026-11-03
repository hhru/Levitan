#if canImport(UIKit)
import Foundation

internal struct TextCacheKey: Hashable, Sendable {

    internal let parts: [AnyTextPart]

    internal let typography: TypographyToken
    internal let decoration: [AnyTextDecorator]

    internal let isEnabled: Bool
    internal let isHovered: Bool
    internal let isPressed: Bool

    internal let tokenTheme: TokenTheme

    internal let hoveredPartIndex: Int?
    internal let pressedPartIndex: Int?

    internal init(
        content: Text,
        context: TextContext,
        hoveredPartIndex: Int?,
        pressedPartIndex: Int?
    ) {
        self.parts = content.parts

        self.typography = context.typography
        self.decoration = context.decoration

        self.isEnabled = context.isEnabled
        self.isHovered = context.isHovered
        self.isPressed = context.isPressed

        self.tokenTheme = context.tokenTheme

        self.hoveredPartIndex = hoveredPartIndex
        self.pressedPartIndex = pressedPartIndex
    }
}
#endif
