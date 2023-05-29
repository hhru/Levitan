import Foundation

internal struct ParagraphFirstLineIndentDecorator<Value: DecorableByParagraphFirstLineIndent>: TokenDecorator {

    internal let paragraphFirstLineIndent: CGFloat?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.paragraphFirstLineIndent(paragraphFirstLineIndent)
    }
}

extension Token where Value: DecorableByParagraphFirstLineIndent {

    public func paragraphFirstLineIndent(_ paragraphFirstLineIndent: CGFloat?) -> Self {
        decorated(
            by: ParagraphFirstLineIndentDecorator(
                paragraphFirstLineIndent: paragraphFirstLineIndent
            )
        )
    }
}
