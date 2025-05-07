#if canImport(UIKit)
import SwiftUI

public struct Text: FallbackManualComponent, TokenValue {

    public typealias UIView = TextView

    nonisolated private var content: TextContent

    public var parts: [AnyTextPart] {
        content.parts
    }

    public var typography: TypographyToken? {
        content.typography
    }

    public var decoration: [AnyTextDecorator] {
        content.decoration
    }

    public var animation: TextAnimation? {
        content.animation
    }

    public var lineLimit: Int? {
        content.lineLimit
    }

    public var lineBreakMode: NSLineBreakMode {
        content.lineBreakMode
    }

    nonisolated public var isEnabled: Bool {
        content.isEnabled
    }

    nonisolated public init(
        parts: [AnyTextPart],
        typography: TypographyToken? = nil,
        decoration: [AnyTextDecorator] = [],
        animation: TextAnimation? = nil,
        lineLimit: Int? = nil,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        isEnabled: Bool = true,
        tapAction: (@MainActor () -> Void)? = nil
    ) {
        self.content = TextContent(
            parts: parts,
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
        _ content: any TextPart,
        typography: TypographyToken? = nil,
        decoration: [AnyTextDecorator] = [],
        animation: TextAnimation? = nil,
        lineLimit: Int? = nil,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        isEnabled: Bool = true,
        tapAction: (@MainActor () -> Void)? = nil
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

    nonisolated public init(
        typography: TypographyToken? = nil,
        decoration: [AnyTextDecorator] = [],
        animation: TextAnimation? = nil,
        lineLimit: Int? = nil,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        isEnabled: Bool = true,
        tapAction: (@MainActor () -> Void)? = nil,
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

    nonisolated public init(stringLiteral value: String) {
        self.init { value }
    }
}

extension Text: ExpressibleByStringInterpolation {

    nonisolated public init(stringInterpolation: TextInterpolation) {
        self.init(parts: stringInterpolation.parts)
    }
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
        changing { $0.content.typography = typography }
    }

    public func decorated<Decorator: TextDecorator>(by decorator: Decorator) -> Self {
        changing { $0.content.decoration.append(decorator.eraseToAnyTextDecorator()) }
    }

    public func animation(_ animation: TextAnimation) -> Self {
        changing { $0.content.animation = animation }
    }

    public func lineLimit(_ lineLimit: Int?) -> Self {
        changing { $0.content.lineLimit = lineLimit }
    }

    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        changing { $0.content.lineBreakMode = lineBreakMode }
    }

    public func disabled(_ isDisabled: Bool = true) -> Self {
        changing { $0.content.isEnabled = !isDisabled }
    }

    public func onTap(_ tapAction: (@MainActor () -> Void)?) -> Self {
        changing { $0.content.tapAction = tapAction }
    }
}

extension Text {

    public func size(
        fitting size: CGSize,
        context: ComponentContext
    ) -> CGSize {
        UIView.size(
            for: self,
            fitting: size,
            context: context
        )
    }

    public func width(
        fitting height: CGFloat = .greatestFiniteMagnitude,
        context: ComponentContext
    ) -> CGFloat {
        size(
            fitting: CGSize(width: .greatestFiniteMagnitude, height: height),
            context: context
        ).width
    }

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
