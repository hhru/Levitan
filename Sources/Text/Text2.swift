import SwiftUI

public struct Text2: FallbackComponent {

    public typealias UIView = TextView

    public let parts: [AnyTextPart]

    public let typography: TypographyToken?
    public let decoration: [AnyTextDecorator]
    public let animation: TextAnimation?

    public let lineLimit: Int?
    public let lineBreakMode: NSLineBreakMode

    public let isEnabled: Bool

    @ViewAction
    public var tapAction: (() -> Void)?

    public init(
        parts: [AnyTextPart],
        typography: TypographyToken? = nil,
        decoration: [AnyTextDecorator] = [],
        animation: TextAnimation? = nil,
        lineLimit: Int? = nil,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        isEnabled: Bool = true,
        tapAction: (() -> Void)? = nil
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
        tapAction: (() -> Void)? = nil
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
        tapAction: (() -> Void)? = nil,
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

extension Text2: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init { value }
    }
}

extension Text2: ExpressibleByStringInterpolation {

    public init(stringInterpolation: TextInterpolation) {
        self.init(parts: stringInterpolation.parts)
    }
}

extension Text2: TextPart {

    public func attributedText(context: ComponentContext) -> NSAttributedString {
        UIView.attributedText(
            for: self,
            context: context
        )
    }
}

extension Text2: Changeable {

    public init(copy: ChangeableWrapper<Self>) {
        self.init(
            parts: copy.parts,
            typography: copy.typography,
            decoration: copy.decoration,
            animation: copy.animation,
            lineLimit: copy.lineLimit,
            lineBreakMode: copy.lineBreakMode,
            isEnabled: copy.isEnabled,
            tapAction: copy.tapAction
        )
    }

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

    public func onTap(_ tapAction: (() -> Void)?) -> Self {
        guard let tapAction else {
            return self
        }

        let newTapAction = { [previousTapAction = self.tapAction] in
            previousTapAction?()
            tapAction()
        }

        return changing { $0.tapAction = newTapAction }
    }
}

extension Text2 {

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

    internal func width(
        fitting height: CGFloat = .greatestFiniteMagnitude,
        context: ComponentContext
    ) -> CGFloat {
        size(
            fitting: CGSize(width: .greatestFiniteMagnitude, height: height),
            context: context
        ).width
    }

    internal func height(
        fitting width: CGFloat = .greatestFiniteMagnitude,
        context: ComponentContext
    ) -> CGFloat {
        size(
            fitting: CGSize(width: width, height: .greatestFiniteMagnitude),
            context: context
        ).height
    }
}
