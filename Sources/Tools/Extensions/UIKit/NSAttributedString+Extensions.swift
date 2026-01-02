#if canImport(UIKit)
import UIKit

extension NSAttributedString {

    internal func size(
        fitting size: CGSize,
        lineLimit: Int? = nil,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> CGSize {
        let lineLimit = lineLimit ?? .zero

        guard lineLimit >= .zero else {
            return .zero
        }

        guard size.width >= .zero, size.height >= .zero else {
            return .zero
        }

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: size)
        let textStorage = NSTextStorage(attributedString: self)

        textContainer.maximumNumberOfLines = lineLimit
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = .zero

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let contentSize = layoutManager
            .usedRect(for: textContainer)
            .size

        return CGSize(
            width: ceil(contentSize.width),
            height: ceil(contentSize.height)
        )
    }
}
#endif
