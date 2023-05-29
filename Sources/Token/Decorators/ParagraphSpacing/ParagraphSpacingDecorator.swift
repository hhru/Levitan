import Foundation

internal struct ParagraphSpacingDecorator<Value: DecorableByParagraphSpacing>: TokenDecorator {

    internal let paragraphSpacing: CGFloat?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.paragraphSpacing(paragraphSpacing)
    }
}

extension Token where Value: DecorableByParagraphSpacing {

    public func paragraphSpacing(_ paragraphSpacing: CGFloat?) -> Self {
        decorated(by: ParagraphSpacingDecorator(paragraphSpacing: paragraphSpacing))
    }
}
