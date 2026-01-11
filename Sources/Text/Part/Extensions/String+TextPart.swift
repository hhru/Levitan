#if canImport(UIKit)
import Foundation

extension String: TextPart {

    public func attributedText(context: TextContext) -> NSAttributedString {
        let typography = context
            .typography
            .resolve(for: context.tokenTheme)

        let attributes = context
            .decoration
            .decorate(typography: typography, context: context)
            .attributes

        return NSAttributedString(
            string: self,
            attributes: attributes
        )
    }
}
#endif
