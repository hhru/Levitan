#if canImport(UIKit)
import UIKit

extension ImageValue: TextPart {

    public func attributedText(context: ComponentContext) -> NSAttributedString {
        let contextTypography = context
            .textTypography
            .resolve(for: context.tokenTheme)

        let typography = context
            .textDecoration
            .decorate(typography: contextTypography, context: context)

        let foregroundColor = typography.foregroundColor

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
            height: imageHeight
        )

        let separator = NSAttributedString(
            string: "\u{001D}",
            attributes: typography.attributes
        )

        let attributedString = NSMutableAttributedString()

        attributedString.append(separator)
        attributedString.append(NSAttributedString(attachment: attachment))
        attributedString.append(separator)

        return attributedString
    }
}
#endif
