#if canImport(UIKit)
import Foundation

extension String: TextPart {

    public func attributedText(context: ComponentContext) -> NSAttributedString {
        let typography = context
            .textTypography
            .resolve(for: context.tokenTheme)

        let attributes = context
            .textDecoration
            .decorate(typography: typography, context: context)
            .attributes

        return NSAttributedString(
            string: self,
            attributes: attributes
        )
    }
}
#endif
