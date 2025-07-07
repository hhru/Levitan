#if canImport(UIKit)
import SwiftUI

public struct Text: FallbackManualComponent, TokenValue {

    public typealias UIView = TextView

    private nonisolated var content: TextContent

    public nonisolated var parts: [AnyTextPart] {
        content.parts
    }

    public nonisolated var typography: TypographyToken? {
        content.typography
    }

    public nonisolated var decoration: [AnyTextDecorator] {
        content.decoration
    }

    public nonisolated var animation: TextAnimation? {
        content.animation
    }

    public nonisolated var lineLimit: Int? {
        content.lineLimit
    }

    public nonisolated var lineBreakMode: NSLineBreakMode {
        content.lineBreakMode
    }

    public nonisolated var isEnabled: Bool {
        content.isEnabled
    }

    public nonisolated init(
        parts: [AnyTextPart],
        typography: TypographyToken? = nil,
        decoration: [AnyTextDecorator] = [],
        animation: TextAnimation? = nil,
        lineLimit: Int? = nil,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        isEnabled: Bool = true,
        tapAction: (@Sendable @MainActor () -> Void)? = nil
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

    public nonisolated init(
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

    public nonisolated init(
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

    public nonisolated init(stringLiteral value: String) {
        self.init { value }
    }
}

extension Text: ExpressibleByStringInterpolation {

    public nonisolated init(stringInterpolation: TextInterpolation) {
        self.init(parts: stringInterpolation.parts)
    }
}

extension Text: TextPart {

    public nonisolated func attributedText(context: ComponentContext) -> NSAttributedString {
        UIView.attributedText(
            for: self,
            context: context
        )
    }
}

extension Text: Changeable {

    public nonisolated func typography(_ typography: TypographyToken?) -> Self {
        changing { $0.content.typography = typography }
    }

    public nonisolated func decorated<Decorator: TextDecorator>(by decorator: Decorator) -> Self {
        changing { $0.content.decoration.append(decorator.eraseToAnyTextDecorator()) }
    }

    public nonisolated func animation(_ animation: TextAnimation) -> Self {
        changing { $0.content.animation = animation }
    }

    public nonisolated func lineLimit(_ lineLimit: Int?) -> Self {
        changing { $0.content.lineLimit = lineLimit }
    }

    public nonisolated func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        changing { $0.content.lineBreakMode = lineBreakMode }
    }

    public nonisolated func disabled(_ isDisabled: Bool = true) -> Self {
        changing { $0.content.isEnabled = !isDisabled }
    }

    public nonisolated func onTap(_ tapAction: (@Sendable @MainActor () -> Void)?) -> Self {
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
