#if canImport(UIKit)
import UIKit

extension UIImage: TextPart {

    public func attributedText(context: TextContext) -> NSAttributedString {
        ImageValue(source: .uiImage(self)).attributedText(context: context)
    }
}
#endif
