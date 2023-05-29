import Foundation

internal struct ParagraphOtherLineIndentDecorator<Value: DecorableByParagraphOtherLineIndent>: TokenDecorator {

    internal let paragraphOtherLineIndent: CGFloat?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.paragraphOtherLineIndent(paragraphOtherLineIndent)
    }
}

extension Token where Value: DecorableByParagraphOtherLineIndent {

    public func paragraphOtherLineIndent(_ paragraphOtherLineIndent: CGFloat?) -> Self {
        decorated(
            by: ParagraphOtherLineIndentDecorator(
                paragraphOtherLineIndent: paragraphOtherLineIndent
            )
        )
    }
}
