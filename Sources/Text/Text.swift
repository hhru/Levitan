#if canImport(UIKit)
import SwiftUI

public struct Text: TokenValue, Sendable {

    public let parts: [AnyTextPart]

    public var typography: TypographyToken?
    public var decoration: [AnyTextDecorator]
    public var animation: TextAnimation?

    public var lineLimit: Int?
    public var lineBreakMode: NSLineBreakMode

    public var isEnabled: Bool

    @ViewAction
    public var tapAction: (@Sendable @MainActor () -> Void)?

    public init(
        parts: [AnyTextPart],
        typography: TypographyToken? = nil,
        decoration: [AnyTextDecorator] = [],
        animation: TextAnimation? = nil,
        lineLimit: Int? = nil,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        isEnabled: Bool = true,
        tapAction: (@Sendable @MainActor () -> Void)? = nil
    ) {
        self.parts = parts

        self.typography = typography
        self.decoration = decoration
        self.animation = animation

        self.lineLimit = lineLimit
        self.lineBreakMode = lineBreakMode

        self.isEnabled = isEnabled

        self.tapAction = tapAction
    }

    public init(
        _ content: any TextPart,
        typography: TypographyToken? = nil,
        decoration: [AnyTextDecorator] = [],
        animation: TextAnimation? = nil,
        lineLimit: Int? = nil,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        isEnabled: Bool = true,
        tapAction: (@Sendable @MainActor () -> Void)? = nil
    ) {
        self.init(
            parts: [content.eraseToAnyTextPart()],
            typography: typography,
            decoration: decoration,
            animation: animation,
            lineLimit: lineLimit,
            lineBreakMode: lineBreakMode,
            isEnabled: isEnabled,
            tapAction: tapAction
        )
    }

    public init(
        typography: TypographyToken? = nil,
        decoration: [AnyTextDecorator] = [],
        animation: TextAnimation? = nil,
        lineLimit: Int? = nil,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        isEnabled: Bool = true,
        tapAction: (@Sendable @MainActor () -> Void)? = nil,
        @TextBuilder content: () -> [any TextPart]
    ) {
        self.init(
            parts: content().map { $0.eraseToAnyTextPart() },
            typography: typography,
            decoration: decoration,
            animation: animation,
            lineLimit: lineLimit,
            lineBreakMode: lineBreakMode,
            isEnabled: isEnabled,
            tapAction: tapAction
        )
    }
}

extension Text: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init { value }
    }
}

extension Text: ExpressibleByStringInterpolation {

    public init(stringInterpolation: TextInterpolation) {
        self.init(parts: stringInterpolation.parts)
    }
}

extension Text: FallbackManualComponent {

    public typealias UIView = TextView
}

extension Text: TextPart {

    public func attributedText(context: ComponentContext) -> NSAttributedString {
        UIView.attributedText(
            for: self,
            context: context
        )
    }
}

extension Text: Changeable {

    public func typography(_ typography: TypographyToken?) -> Self {
        changing { $0.typography = typography }
    }

    public func decorated<Decorator: TextDecorator>(by decorator: Decorator) -> Self {
        changing { $0.decoration.append(decorator.eraseToAnyTextDecorator()) }
    }

    public func animation(_ animation: TextAnimation) -> Self {
        changing { $0.animation = animation }
    }

    public func lineLimit(_ lineLimit: Int?) -> Self {
        changing { $0.lineLimit = lineLimit }
    }

    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        changing { $0.lineBreakMode = lineBreakMode }
    }

    public func disabled(_ isDisabled: Bool = true) -> Self {
        changing { $0.isEnabled = !isDisabled }
    }

    public func onTap(_ tapAction: (@Sendable @MainActor () -> Void)?) -> Self {
        changing { $0.tapAction = tapAction }
    }
}

extension Text {

    @MainActor
    public func width(
        fitting height: CGFloat = .greatestFiniteMagnitude,
        context: ComponentContext
    ) -> CGFloat {
        size(
            fitting: CGSize(width: .greatestFiniteMagnitude, height: height),
            context: context
        ).width
    }

    @MainActor
    public func height(
        fitting width: CGFloat = .greatestFiniteMagnitude,
        context: ComponentContext
    ) -> CGFloat {
        size(
            fitting: CGSize(width: width, height: .greatestFiniteMagnitude),
            context: context
        ).height
    }
}
#endif
