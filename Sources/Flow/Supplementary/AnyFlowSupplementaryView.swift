#if canImport(UIKit)
import UIKit

open class AnyFlowSupplementaryView: UICollectionReusableView {

    open class var reuseIdentifier: String {
        "\(ObjectIdentifier(Self.self))"
    }

    open func onAppear() { }
    open func onDisappear() { }

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        guard let layoutAttributes = layoutAttributes as? CollectionViewLayoutAttributes else {
            return super.apply(layoutAttributes)
        }

        print(
            "\(Self.self)<\(Unmanaged.passUnretained(self).toOpaque())>.\(#function)",
            "attibutes:", Unmanaged.passUnretained(layoutAttributes).toOpaque(),
            "y:", layoutAttributes.frame.minY,
            "height:", layoutAttributes.frame.height,
            "estimated:", layoutAttributes.sizing != nil
        )

        super.apply(layoutAttributes)
    }

    open override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        guard let layoutAttributes = layoutAttributes as? CollectionViewLayoutAttributes else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }

        print(
            "\(Self.self)<\(Unmanaged.passUnretained(self).toOpaque())>.\(#function)",
            "attibutes:", Unmanaged.passUnretained(layoutAttributes).toOpaque(),
            "y:", layoutAttributes.frame.minY,
            "height:", layoutAttributes.frame.height,
            "estimated:", layoutAttributes.sizing != nil
        )

        guard let sizing = layoutAttributes.sizing else {
            return layoutAttributes
        }

        layoutAttributes.size = size(for: sizing)

        return layoutAttributes
    }

    private func size(for sizing: CollectionViewLayoutSizing) -> CGSize {
        switch (sizing.width, sizing.height) {
        case let (.fixed(fixedWidth), .fixed(fixedHeight)):
            sizeWithFixedWidthAndFixedHeight(
                fixedWidth: fixedWidth,
                fixedHeight: fixedHeight
            )

        case let (.fixed(fixedWidth), .hug(isHeightForced)):
            sizeWithFixedWidthAndHuggingHeight(
                fixedWidth: fixedWidth,
                proposedHeight: isHeightForced ? nil : sizing.proposedSize.height
            )

        case let (.fixed(fixedWidth), .fill):
            sizeWithFixedWidthAndFillingHeight(
                fixedWidth: fixedWidth,
                proposedHeight: sizing.proposedSize.height
            )

        case let (.hug(isWidthForced), .hug(isHeightForced)):
            sizeWithHuggingWidthAndHuggingHeight(
                proposedWidth: isWidthForced ? nil : sizing.proposedSize.width,
                proposedHeight: isHeightForced ? nil : sizing.proposedSize.height
            )

        case let (.hug(isWidthForced), .fixed(fixedHeight)):
            sizeWithHuggingWidthAndFixedHeight(
                proposedWidth: isWidthForced ? nil : sizing.proposedSize.width,
                fixedHeight: fixedHeight
            )

        case let (.hug(isWidthForced), .fill):
            sizeWithHuggingWidthAndFillingHeight(
                proposedWidth: isWidthForced ? nil : sizing.proposedSize.width,
                proposedHeight: sizing.proposedSize.height
            )

        case (.fill, .fill):
            sizeWithFillingWidthAndFillingHeight(
                proposedWidth: sizing.proposedSize.width,
                proposedHeight: sizing.proposedSize.height
            )

        case let (.fill, .fixed(fixedHeight)):
            sizeWithFillingWidthAndFixedHeight(
                proposedWidth: sizing.proposedSize.width,
                fixedHeight: fixedHeight
            )

        case let (.fill, .hug(isHeightForced)):
            sizeWithFillingWidthAndHuggingHeight(
                proposedWidth: sizing.proposedSize.width,
                proposedHeight: isHeightForced ? nil : sizing.proposedSize.height
            )
        }
    }
}
#endif
