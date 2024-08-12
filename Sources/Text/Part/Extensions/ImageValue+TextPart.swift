import UIKit

extension ImageValue: TextPart {

    public func attributedText(context: ComponentContext) -> NSAttributedString {
        let typography = context
            .textTypography
            .resolve(for: context.tokenTheme)

        let foregroundColor = context
            .textDecoration
            .decorate(typography: typography, context: context)
            .foregroundColor

        let uiImage = self
            .foregroundColor(self.foregroundColor ?? foregroundColor)
            .uiImage

        let attachment = NSTextAttachment(image: uiImage)

        return NSAttributedString(attachment: attachment)
    }
}
