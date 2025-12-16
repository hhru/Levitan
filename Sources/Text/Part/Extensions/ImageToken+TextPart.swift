#if canImport(UIKit)
import Foundation

extension ImageToken: TextPart {

    public func attributedText(context: TextContext) -> NSAttributedString {
        self
            .resolve(for: context.tokenTheme)
            .attributedText(context: context)
    }
}
#endif
