#if canImport(UIKit)
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

        let imageHeight = uiImage.size.height
        let capHeight = typography.font.uiFont.capHeight

        let attachment = NSTextAttachment(image: uiImage)

        attachment.bounds = CGRect(
            x: .zero,
            y: (capHeight - imageHeight) * 0.5,
            width: uiImage.size.width,
            height: uiImage.size.height
        )

        return NSAttributedString(attachment: attachment)
    }
}
#endif
