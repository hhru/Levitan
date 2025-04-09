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

    internal func width(
        fitting height: CGFloat = .greatestFiniteMagnitude,
        lineLimit: Int? = nil,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> CGFloat {
        size(
            fitting: CGSize(width: .greatestFiniteMagnitude, height: height),
            lineLimit: lineLimit,
            lineBreakMode: lineBreakMode
        ).width
    }

    internal func height(
        fitting width: CGFloat = .greatestFiniteMagnitude,
        lineLimit: Int? = nil,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> CGFloat {
        size(
            fitting: CGSize(width: width, height: .greatestFiniteMagnitude),
            lineLimit: lineLimit,
            lineBreakMode: lineBreakMode
        ).height
    }
}
#endif
