#if canImport(UIKit)
import Foundation

public struct TextContext: Hashable, Sendable {

    public var typography: TypographyToken
    public var decoration: [AnyTextDecorator]
    public var animation: TextAnimation

    public var isEnabled: Bool
    public var isHovered: Bool
    public var isPressed: Bool

    public var tokenTheme: TokenTheme
}

extension TextContext: Changeable {

    internal func hovered(_ isHovered: Bool) -> Self {
        changing { $0.isHovered = isHovered || self.isHovered }
    }

    internal func pressed(_ isPressed: Bool) -> Self {
        changing { $0.isPressed = isPressed || self.isPressed }
    }

    internal func tokenTheme(_ tokenTheme: TokenTheme) -> Self {
        changing { $0.tokenTheme = tokenTheme }
    }
}
#endif
