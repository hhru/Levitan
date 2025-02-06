#if canImport(UIKit1)
import UIKit

extension UIImage: TextPart {

    public func attributedText(context: ComponentContext) -> NSAttributedString {
        ImageValue(source: .uiImage(self)).attributedText(context: context)
    }
}
#endif
